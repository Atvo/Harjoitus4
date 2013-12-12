class Mirror {
  boolean leftOrRight;
  Side side;

  public Mirror(boolean leftOrRight, Side side) {
    this.leftOrRight = leftOrRight;
    this.side = side;
  }

  Side changeLaserDirection(Side from) {
    if (from == Side.FRONT) {
      if (this.side == Side.LEFT || this.side == Side.RIGHT) {
        if (leftOrRight) {
          return Side.TOP;
        }
        return Side.BOTTOM;
      }
      if (this.side == Side.TOP || this.side == Side.BOTTOM) {
        if (leftOrRight) {
          return Side.LEFT;
        }
        return Side.RIGHT;
      }
    }

    if (from == Side.RIGHT) {
      if (this.side == Side.FRONT || this.side == Side.BACK) {
        if (leftOrRight) {
          return Side.TOP;
        }
        return Side.BOTTOM;
      }
      if (this.side == Side.TOP || this.side == Side.BOTTOM) {
        if (leftOrRight) {
          return Side.BACK;
        }
        return Side.FRONT;
      }
    }

    if (from == Side.BACK) {
      if (this.side == Side.LEFT || this.side == Side.RIGHT) {
        if (leftOrRight) {
          return Side.BOTTOM;
        }
        return Side.TOP;
      }
      if (this.side == Side.TOP || this.side == Side.BOTTOM) {
        if (leftOrRight) {
          return Side.RIGHT;
        }
        return Side.LEFT;
      }
    }

    if (from == Side.LEFT) {
      if (this.side == Side.FRONT || this.side == Side.BACK) {
        if (leftOrRight) {
          return Side.BOTTOM;
        }
        return Side.TOP;
      }
      if (this.side == Side.TOP || this.side == Side.BOTTOM) {
        if (leftOrRight) {
          return Side.FRONT;
        }
        return Side.BACK;
      }
    }

    if (from == Side.TOP) {
      if (this.side == Side.FRONT || this.side == Side.BACK) {
        if (leftOrRight) {
          return Side.RIGHT;
        }
        return Side.LEFT;
      }
      if (this.side == Side.RIGHT || this.side == Side.LEFT) {
        if (leftOrRight) {
          return Side.FRONT;
        }
        return Side.BACK;
      }
    }

    if (from == Side.BOTTOM) {
      if (this.side == Side.FRONT || this.side == Side.BACK) {
        if (leftOrRight) {
          return Side.LEFT;
        }
        return Side.RIGHT;
      }
      if (this.side == Side.RIGHT || this.side == Side.LEFT) {
        if (leftOrRight) {
          return Side.BACK;
        }
        return Side.FRONT;
      }
    }
    return null;
  }
}

