/**
 * 環境変数 key を読み込み
 * defaultValue を指定しない場合はエラー
 */
export const getEnv = (key: string, defaultValue?: string): string => {
  const value = import.meta.env[key] ?? defaultValue;
  if (!value) {
    throw new Error(`環境変数 ${key} が設定されていません。`);
  }
  return value;
};
