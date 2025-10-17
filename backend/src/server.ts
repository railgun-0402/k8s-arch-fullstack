import express from "express";
import appConfig from "./libs/appConfig";
import { PrismaClient } from "./generated/prisma";

const app = express();
const dbClient = new PrismaClient();

const PORT = appConfig.port;
const version = appConfig.shortSHA;
const buildTime = appConfig.buildTime;
const nodeEnv = appConfig.nodeEnv;

app.get("/public/health", async (_req, res) => {
  let dbStatus = "ok";

  try {
    await dbClient.$queryRaw`SELECT 1`;
  } catch (error) {
    dbStatus = "error";
    console.error("[HealthCheck] DB connection failed:", error);
  }

  res.status(200).json({
    status: "ok",
    version,
    buildTime,
    nodeEnv,
    dbStatus,
  });
});

app.listen(PORT, () => {
  console.log(
    {
      PORT: PORT,
      VERSION: version,
      BUILD_TIME: buildTime,
      NODE_ENV: nodeEnv,
    },
    "🚀 Server started"
  );
});
