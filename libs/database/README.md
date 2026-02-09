# @tftstocks/database

Database layer for TFT Stocks application.

## What's Inside

- **BaseRepository** - Generic repository with common CRUD operations
- **PrismaService** - Prisma client with lifecycle hooks
- **DatabaseModule** - Global NestJS module for database access

## Usage

### 1. Import DatabaseModule (One-time setup)

In your `app.module.ts`:

```typescript
import { DatabaseModule } from '@tftstocks/database';

@Module({
  imports: [DatabaseModule], // Global module
})
export class AppModule {}
```

### 2. Create a Repository

```typescript
import { Injectable } from '@nestjs/common';
import { BaseRepository, PrismaService } from '@tftstocks/database';
import { Stock } from '@prisma/client';

@Injectable()
export class StockRepository extends BaseRepository<Stock> {
  constructor(prisma: PrismaService) {
    super(prisma, 'stock'); // 'stock' is the Prisma model name
  }

  // Add custom methods
  async findByPuuid(puuid: string) {
    return this.findOne({ where: { puuid } });
  }

  async findTopPerformers(limit: number) {
    return this.findAll({
      orderBy: { currentPrice: 'desc' },
      take: limit,
    });
  }
}
```

### 3. Use in Service

```typescript
import { Injectable } from '@nestjs/common';
import { StockRepository } from './stock.repository';

@Injectable()
export class StockService {
  constructor(private stockRepository: StockRepository) {}

  async getTopStocks() {
    return this.stockRepository.findTopPerformers(10);
  }
}
```

## BaseRepository API

All repositories inherit these methods:

### Find Operations
- `findAll(options?)` - Find all records with optional filters
- `findById(id, include?)` - Find by ID
- `findOne(options)` - Find single record by criteria
- `findFirst(options)` - Find first matching record

### Create/Update
- `create(data)` - Create a new record
- `update(id, data)` - Update a record
- `updateMany(where, data)` - Update multiple records
- `upsert(where, create, update)` - Create or update

### Delete
- `delete(id)` - Delete by ID
- `deleteMany(where)` - Delete multiple records

### Utilities
- `count(where?)` - Count records
- `exists(where)` - Check if record exists

## Architecture

```
Service (Business Logic)
    ↓
Repository (Data Access)
    ↓
Prisma (ORM)
    ↓
PostgreSQL
```

## Benefits

✅ **DRY** - Common operations inherited from BaseRepository
✅ **Type-Safe** - Full TypeScript + Prisma type safety
✅ **Testable** - Easy to mock repositories
✅ **Maintainable** - Database logic separated from business logic
✅ **Extensible** - Add custom methods per repository
