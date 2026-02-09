#!/bin/bash

# Generate NestJS Resource with Repository Pattern
# Usage: ./scripts/generate-resource.sh <resource-name>

if [ -z "$1" ]; then
  echo "Error: Resource name is required"
  echo "Usage: ./scripts/generate-resource.sh <resource-name>"
  exit 1
fi

RESOURCE_NAME=$1
RESOURCE_PATH="apps/api/src/app/${RESOURCE_NAME}"

# Convert to PascalCase for class name (capitalize first letter)
CLASS_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${RESOURCE_NAME:0:1})${RESOURCE_NAME:1}"

echo "🔨 Generating NestJS resource: ${RESOURCE_NAME}"

# Create directory structure
mkdir -p "${RESOURCE_PATH}/dto"
mkdir -p "${RESOURCE_PATH}/entities"

# Create Module
cat > "${RESOURCE_PATH}/${RESOURCE_NAME}.module.ts" << EOF
import { Module } from '@nestjs/common';
import { ${CLASS_NAME}Service } from './${RESOURCE_NAME}.service';
import { ${CLASS_NAME}Resolver } from './${RESOURCE_NAME}.resolver';
import { ${CLASS_NAME}Repository } from './${RESOURCE_NAME}.repository';

@Module({
  providers: [${CLASS_NAME}Resolver, ${CLASS_NAME}Service, ${CLASS_NAME}Repository],
  exports: [${CLASS_NAME}Service, ${CLASS_NAME}Repository],
})
export class ${CLASS_NAME}Module {}
EOF

# Create Repository
cat > "${RESOURCE_PATH}/${RESOURCE_NAME}.repository.ts" << EOF
import { Injectable } from '@nestjs/common';
import { BaseRepository, PrismaService } from '@tftstocks/database';
import { ${CLASS_NAME} } from '@prisma/client';

@Injectable()
export class ${CLASS_NAME}Repository extends BaseRepository<${CLASS_NAME}> {
  constructor(prisma: PrismaService) {
    super(prisma, '${RESOURCE_NAME}');
  }

  // Add custom repository methods here
  // Example:
  // async findByEmail(email: string): Promise<${CLASS_NAME} | null> {
  //   return this.findOne({ where: { email } });
  // }
}
EOF

# Create Service
cat > "${RESOURCE_PATH}/${RESOURCE_NAME}.service.ts" << EOF
import { Injectable } from '@nestjs/common';
import { ${CLASS_NAME}Repository } from './${RESOURCE_NAME}.repository';
import { Create${CLASS_NAME}Input } from './dto/create-${RESOURCE_NAME}.input';
import { Update${CLASS_NAME}Input } from './dto/update-${RESOURCE_NAME}.input';

@Injectable()
export class ${CLASS_NAME}Service {
  constructor(private readonly ${RESOURCE_NAME}Repository: ${CLASS_NAME}Repository) {}

  async create(createInput: Create${CLASS_NAME}Input) {
    return this.${RESOURCE_NAME}Repository.create(createInput as any);
  }

  async findAll() {
    return this.${RESOURCE_NAME}Repository.findAll();
  }

  async findOne(id: string) {
    const ${RESOURCE_NAME} = await this.${RESOURCE_NAME}Repository.findById(id);
    if (!${RESOURCE_NAME}) {
      throw new Error('${CLASS_NAME} not found');
    }
    return ${RESOURCE_NAME};
  }

  async update(id: string, updateInput: Update${CLASS_NAME}Input) {
    await this.findOne(id); // Ensure exists
    return this.${RESOURCE_NAME}Repository.update(id, updateInput as any);
  }

  async remove(id: string) {
    await this.findOne(id); // Ensure exists
    return this.${RESOURCE_NAME}Repository.delete(id);
  }
}
EOF

# Create Resolver
cat > "${RESOURCE_PATH}/${RESOURCE_NAME}.resolver.ts" << EOF
import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { ${CLASS_NAME}Service } from './${RESOURCE_NAME}.service';
import { ${CLASS_NAME} } from './entities/${RESOURCE_NAME}.entity';
import { Create${CLASS_NAME}Input } from './dto/create-${RESOURCE_NAME}.input';
import { Update${CLASS_NAME}Input } from './dto/update-${RESOURCE_NAME}.input';

@Resolver(() => ${CLASS_NAME})
export class ${CLASS_NAME}Resolver {
  constructor(private readonly ${RESOURCE_NAME}Service: ${CLASS_NAME}Service) {}

  @Mutation(() => ${CLASS_NAME})
  create${CLASS_NAME}(@Args('createInput') createInput: Create${CLASS_NAME}Input) {
    return this.${RESOURCE_NAME}Service.create(createInput);
  }

  @Query(() => [${CLASS_NAME}], { name: '${RESOURCE_NAME}s' })
  findAll() {
    return this.${RESOURCE_NAME}Service.findAll();
  }

  @Query(() => ${CLASS_NAME}, { name: '${RESOURCE_NAME}' })
  findOne(@Args('id') id: string) {
    return this.${RESOURCE_NAME}Service.findOne(id);
  }

  @Mutation(() => ${CLASS_NAME})
  update${CLASS_NAME}(
    @Args('id') id: string,
    @Args('updateInput') updateInput: Update${CLASS_NAME}Input
  ) {
    return this.${RESOURCE_NAME}Service.update(id, updateInput);
  }

  @Mutation(() => ${CLASS_NAME})
  remove${CLASS_NAME}(@Args('id') id: string) {
    return this.${RESOURCE_NAME}Service.remove(id);
  }
}
EOF

# Create Entity
cat > "${RESOURCE_PATH}/entities/${RESOURCE_NAME}.entity.ts" << EOF
import { ObjectType, Field, ID } from '@nestjs/graphql';

@ObjectType()
export class ${CLASS_NAME} {
  @Field(() => ID)
  id: string;

  @Field()
  createdAt: Date;

  @Field()
  updatedAt: Date;

  // TODO: Add your fields here
}
EOF

# Create Create Input
cat > "${RESOURCE_PATH}/dto/create-${RESOURCE_NAME}.input.ts" << EOF
import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class Create${CLASS_NAME}Input {
  // TODO: Add your input fields here
  // Example:
  // @Field()
  // name: string;
}
EOF

# Create Update Input
cat > "${RESOURCE_PATH}/dto/update-${RESOURCE_NAME}.input.ts" << EOF
import { InputType, Field, PartialType } from '@nestjs/graphql';
import { Create${CLASS_NAME}Input } from './create-${RESOURCE_NAME}.input';

@InputType()
export class Update${CLASS_NAME}Input extends PartialType(Create${CLASS_NAME}Input) {
  // All fields from Create${CLASS_NAME}Input are optional here
}
EOF

echo "✅ Resource generated successfully!"
echo ""
echo "📁 Created files in ${RESOURCE_PATH}/"
echo "  ├── ${RESOURCE_NAME}.module.ts"
echo "  ├── ${RESOURCE_NAME}.resolver.ts (GraphQL endpoints)"
echo "  ├── ${RESOURCE_NAME}.service.ts (Business logic)"
echo "  ├── ${RESOURCE_NAME}.repository.ts (Database operations)"
echo "  ├── dto/"
echo "  │   ├── create-${RESOURCE_NAME}.input.ts"
echo "  │   └── update-${RESOURCE_NAME}.input.ts"
echo "  └── entities/"
echo "      └── ${RESOURCE_NAME}.entity.ts"
echo ""
echo "📝 Next steps:"
echo "  1. Add fields to entities/${RESOURCE_NAME}.entity.ts"
echo "  2. Add input fields to dto/create-${RESOURCE_NAME}.input.ts"
echo "  3. Add business logic to ${RESOURCE_NAME}.service.ts"
echo "  4. Add custom queries to ${RESOURCE_NAME}.repository.ts"
echo "  5. Import ${CLASS_NAME}Module in app.module.ts"