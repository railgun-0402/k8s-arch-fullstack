import { AppRoleType } from "./appRole";

/**
 * ログインユーザー情報
 */
export type CurrentUser = {
  sub: string;
  email: string;
  role: AppRoleType;
};
