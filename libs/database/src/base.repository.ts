import { Injectable } from '@nestjs/common';

export interface BaseEntity {
  id: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface FindManyOptions<T> {
  where?: Partial<T>;
  orderBy?: Record<string, 'asc' | 'desc'>;
  take?: number;
  skip?: number;
  include?: Record<string, boolean | object>;
}

export interface FindOneOptions<T> {
  where: Partial<T>;
  include?: Record<string, boolean | object>;
}

/**
 * Base repository providing common CRUD operations for Prisma models.
 *
 * @example
 * ```typescript
 * @Injectable()
 * export class StockRepository extends BaseRepository<Stock> {
 *   constructor(prisma: PrismaService) {
 *     super(prisma, 'stock');
 *   }
 *
 *   // Add custom methods
 *   async findByPuuid(puuid: string) {
 *     return this.findOne({ where: { puuid } });
 *   }
 * }
 * ```
 */
@Injectable()
export abstract class BaseRepository<T extends BaseEntity> {
  constructor(
    protected readonly prisma: any,
    protected readonly modelName: string
  ) {}

  /**
   * Get the Prisma model delegate for this repository
   */
  protected get model() {
    return this.prisma[this.modelName];
  }

  /**
   * Create a new record
   */
  async create(data: Omit<T, 'id' | 'createdAt' | 'updatedAt'>): Promise<T> {
    return this.model.create({ data });
  }

  /**
   * Find all records with optional filters
   */
  async findAll(options: FindManyOptions<T> = {}): Promise<T[]> {
    return this.model.findMany(options);
  }

  /**
   * Find a single record by ID
   */
  async findById(id: string, include?: Record<string, boolean | object>): Promise<T | null> {
    return this.model.findUnique({
      where: { id },
      include,
    });
  }

  /**
   * Find a single record by custom criteria
   */
  async findOne(options: FindOneOptions<T>): Promise<T | null> {
    return this.model.findUnique(options);
  }

  /**
   * Find first record matching criteria
   */
  async findFirst(options: FindManyOptions<T> = {}): Promise<T | null> {
    return this.model.findFirst(options);
  }

  /**
   * Update a record by ID
   */
  async update(id: string, data: Partial<Omit<T, 'id' | 'createdAt' | 'updatedAt'>>): Promise<T> {
    return this.model.update({
      where: { id },
      data,
    });
  }

  /**
   * Update many records matching criteria
   */
  async updateMany(where: Partial<T>, data: Partial<Omit<T, 'id' | 'createdAt' | 'updatedAt'>>): Promise<{ count: number }> {
    return this.model.updateMany({
      where,
      data,
    });
  }

  /**
   * Delete a record by ID
   */
  async delete(id: string): Promise<T> {
    return this.model.delete({
      where: { id },
    });
  }

  /**
   * Delete many records matching criteria
   */
  async deleteMany(where: Partial<T>): Promise<{ count: number }> {
    return this.model.deleteMany({ where });
  }

  /**
   * Count records matching criteria
   */
  async count(where: Partial<T> = {}): Promise<number> {
    return this.model.count({ where });
  }

  /**
   * Check if a record exists
   */
  async exists(where: Partial<T>): Promise<boolean> {
    const count = await this.count(where);
    return count > 0;
  }

  /**
   * Upsert - create or update a record
   */
  async upsert(
    where: Partial<T>,
    create: Omit<T, 'id' | 'createdAt' | 'updatedAt'>,
    update: Partial<Omit<T, 'id' | 'createdAt' | 'updatedAt'>>
  ): Promise<T> {
    return this.model.upsert({
      where,
      create,
      update,
    });
  }
}
