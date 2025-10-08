import { useTheme, useMediaQuery } from "@mui/material";

export const useDevice = () => {
  const theme = useTheme();

  /**
   * タブレットやスマホかどうか判定
   */
  const isTabletOrDown = useMediaQuery(theme.breakpoints.down("md"));

  return {
    isTabletOrDown,
  };
};
