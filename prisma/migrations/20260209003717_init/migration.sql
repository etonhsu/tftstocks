-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "avatarUrl" TEXT,
    "balance" DECIMAL(12,2) NOT NULL DEFAULT 10000,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OAuthAccount" (
    "id" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "providerDisplayName" TEXT,
    "providerAvatarUrl" TEXT,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OAuthAccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Stock" (
    "id" TEXT NOT NULL,
    "puuid" TEXT NOT NULL,
    "summonerId" TEXT NOT NULL,
    "gameName" TEXT NOT NULL,
    "gameNameLower" TEXT NOT NULL,
    "tagLine" TEXT NOT NULL,
    "region" TEXT NOT NULL DEFAULT 'NA',
    "rank" TEXT NOT NULL,
    "lp" INTEGER NOT NULL,
    "winRate" DECIMAL(5,4) NOT NULL,
    "gamesPlayed" INTEGER NOT NULL DEFAULT 0,
    "streakType" TEXT NOT NULL DEFAULT 'NONE',
    "streakLength" INTEGER NOT NULL DEFAULT 0,
    "streakLastGame" TIMESTAMP(3),
    "streakBonus" DECIMAL(6,2) NOT NULL DEFAULT 0,
    "currentPrice" DECIMAL(10,2) NOT NULL,
    "fundamentalValue" DECIMAL(10,2) NOT NULL,
    "marketSentiment" DECIMAL(5,4) NOT NULL DEFAULT 0,
    "emaLP" DECIMAL(10,2) NOT NULL,
    "delta8h" DECIMAL(10,2),
    "delta24h" DECIMAL(10,2),
    "delta72h" DECIMAL(10,2),
    "preResetFV" DECIMAL(10,2),
    "seasonResetAt" TIMESTAMP(3),
    "delistDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Stock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PriceSnapshot" (
    "id" TEXT NOT NULL,
    "stockId" TEXT NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "fundamentalValue" DECIMAL(10,2) NOT NULL,
    "marketSentiment" DECIMAL(5,4) NOT NULL,
    "lp" INTEGER NOT NULL,
    "rank" TEXT NOT NULL,
    "granularity" TEXT NOT NULL DEFAULT 'RAW',
    "recordedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PriceSnapshot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Holding" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "stockId" TEXT NOT NULL,
    "shares" DECIMAL(10,2) NOT NULL,
    "avgBuyPrice" DECIMAL(10,2) NOT NULL,
    "holdDeadline" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Holding_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "stockId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "shares" DECIMAL(10,2) NOT NULL,
    "pricePerShare" DECIMAL(10,2) NOT NULL,
    "totalAmount" DECIMAL(12,2) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DemandEvent" (
    "id" TEXT NOT NULL,
    "stockId" TEXT NOT NULL,
    "netShares" DECIMAL(10,2) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DemandEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "League" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "inviteCode" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'PRIVATE',
    "createdById" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "maxMembers" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "League_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LeagueMember" (
    "id" TEXT NOT NULL,
    "leagueId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "portfolioValueAtJoin" DECIMAL(12,2) NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LeagueMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Watchlist" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "stockId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Watchlist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PortfolioSnapshot" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "totalValue" DECIMAL(12,2) NOT NULL,
    "holdingsValue" DECIMAL(12,2) NOT NULL,
    "cashBalance" DECIMAL(12,2) NOT NULL,
    "granularity" TEXT NOT NULL DEFAULT 'RAW',
    "recordedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PortfolioSnapshot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PricingConfig" (
    "id" TEXT NOT NULL DEFAULT 'default',
    "emaAlpha" DECIMAL(4,2) NOT NULL DEFAULT 0.3,
    "challengerBase" DECIMAL(6,2) NOT NULL DEFAULT 80,
    "grandmasterBase" DECIMAL(6,2) NOT NULL DEFAULT 50,
    "masterBase" DECIMAL(6,2) NOT NULL DEFAULT 25,
    "challengerLPScalar" DECIMAL(4,2) NOT NULL DEFAULT 0.15,
    "grandmasterLPScalar" DECIMAL(4,2) NOT NULL DEFAULT 0.10,
    "masterLPScalar" DECIMAL(4,2) NOT NULL DEFAULT 0.05,
    "winRateMultiplier" DECIMAL(4,2) NOT NULL DEFAULT 0.5,
    "winRateWindow" INTEGER NOT NULL DEFAULT 30,
    "streakValue" DECIMAL(4,2) NOT NULL DEFAULT 0.50,
    "streakCap" DECIMAL(6,2) NOT NULL DEFAULT 5.00,
    "streakDecayPerDay" DECIMAL(4,2) NOT NULL DEFAULT 0.50,
    "sentimentK" DECIMAL(4,2) NOT NULL DEFAULT 0.10,
    "sentimentS" DECIMAL(8,2) NOT NULL DEFAULT 100,
    "sentimentClamp" DECIMAL(4,2) NOT NULL DEFAULT 0.25,
    "demandWindowDays" INTEGER NOT NULL DEFAULT 7,
    "seasonTransitionTau" INTEGER NOT NULL DEFAULT 7,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PricingConfig_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "OAuthAccount_provider_providerAccountId_key" ON "OAuthAccount"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Stock_puuid_key" ON "Stock"("puuid");

-- CreateIndex
CREATE UNIQUE INDEX "Stock_summonerId_key" ON "Stock"("summonerId");

-- CreateIndex
CREATE INDEX "Stock_gameNameLower_idx" ON "Stock"("gameNameLower");

-- CreateIndex
CREATE INDEX "Stock_rank_currentPrice_idx" ON "Stock"("rank", "currentPrice");

-- CreateIndex
CREATE INDEX "PriceSnapshot_stockId_recordedAt_idx" ON "PriceSnapshot"("stockId", "recordedAt");

-- CreateIndex
CREATE INDEX "PriceSnapshot_stockId_granularity_recordedAt_idx" ON "PriceSnapshot"("stockId", "granularity", "recordedAt");

-- CreateIndex
CREATE UNIQUE INDEX "Holding_userId_stockId_key" ON "Holding"("userId", "stockId");

-- CreateIndex
CREATE INDEX "Transaction_userId_createdAt_idx" ON "Transaction"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "Transaction_stockId_createdAt_idx" ON "Transaction"("stockId", "createdAt");

-- CreateIndex
CREATE INDEX "DemandEvent_stockId_createdAt_idx" ON "DemandEvent"("stockId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "League_inviteCode_key" ON "League"("inviteCode");

-- CreateIndex
CREATE UNIQUE INDEX "LeagueMember_leagueId_userId_key" ON "LeagueMember"("leagueId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "Watchlist_userId_stockId_key" ON "Watchlist"("userId", "stockId");

-- CreateIndex
CREATE INDEX "PortfolioSnapshot_userId_recordedAt_idx" ON "PortfolioSnapshot"("userId", "recordedAt");

-- CreateIndex
CREATE INDEX "PortfolioSnapshot_userId_granularity_recordedAt_idx" ON "PortfolioSnapshot"("userId", "granularity", "recordedAt");

-- AddForeignKey
ALTER TABLE "OAuthAccount" ADD CONSTRAINT "OAuthAccount_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PriceSnapshot" ADD CONSTRAINT "PriceSnapshot_stockId_fkey" FOREIGN KEY ("stockId") REFERENCES "Stock"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Holding" ADD CONSTRAINT "Holding_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Holding" ADD CONSTRAINT "Holding_stockId_fkey" FOREIGN KEY ("stockId") REFERENCES "Stock"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_stockId_fkey" FOREIGN KEY ("stockId") REFERENCES "Stock"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DemandEvent" ADD CONSTRAINT "DemandEvent_stockId_fkey" FOREIGN KEY ("stockId") REFERENCES "Stock"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LeagueMember" ADD CONSTRAINT "LeagueMember_leagueId_fkey" FOREIGN KEY ("leagueId") REFERENCES "League"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LeagueMember" ADD CONSTRAINT "LeagueMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Watchlist" ADD CONSTRAINT "Watchlist_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Watchlist" ADD CONSTRAINT "Watchlist_stockId_fkey" FOREIGN KEY ("stockId") REFERENCES "Stock"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PortfolioSnapshot" ADD CONSTRAINT "PortfolioSnapshot_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
