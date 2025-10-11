const getEnv = (key: string, defaultValue?: string): string => {
  const value = process.env[key] ?? defaultValue;
  if (!value) {
    throw new Error(`環境変数 ${key} が設定されてません`);
  }
  return value;
};

const appConfig = {
  nodeEnv: getEnv("NODE_ENV", "development"),
  port: Number(getEnv("APP_PORT", "8080")),
  shortSHA: getEnv("SHORT_SHA", "local"),
  buildTime: getEnv("BUILD_TIME", new Date().toISOString()),
};

export default appConfig;
