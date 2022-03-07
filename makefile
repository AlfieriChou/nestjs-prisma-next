##################################################################################
DATA_SOURCE ?= main
MIGRATION_NAME ?= init

preCatDatasourceFile:
	rm -rf ./src/prisma/$(DATA_SOURCE).prisma

catDatasourceFile: preCatDatasourceFile
	cat ./src/prisma/datasource/$(DATA_SOURCE).prisma >> ./src/prisma/$(DATA_SOURCE).prisma

catMultiPrismaFile: catDatasourceFile
	cat ./src/prisma/models/$(DATA_SOURCE)/*.prisma >> ./src/prisma/$(DATA_SOURCE).prisma

migrateDev: catMultiPrismaFile
	prisma migrate dev --schema src/prisma/$(DATA_SOURCE).prisma --name $(DATA_SOURCE)_$(MIGRATION_NAME) --skip-generate
	rm -rf prisma/$(DATA_SOURCE).prisma

migrate: catMultiPrismaFile
	prisma migrate deploy --schema src/prisma/$(DATA_SOURCE).prisma
	rm -rf prisma/$(DATA_SOURCE).prisma

migrateReset: catMultiPrismaFile
	prisma migrate reset --schema src/prisma/$(DATA_SOURCE).prisma
	rm -rf prisma/$(DATA_SOURCE).prisma

studio: catMultiPrismaFile
	sudo prisma studio --schema=src/prisma/$(DATA_SOURCE).prisma
