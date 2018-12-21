package g2d.geom;

import h2d.Graphics;
import gxd.sys.ds.Pool;
import hxmath.math.Vector2;

using g2d.Collisions;

typedef RectType = {
  var x:Float;
  var y:Float;
  var width:Float;
  var height:Float;
}

class Rect extends Shape implements IPooled {
  public static var pool(get, never):IPool<Rect>;
  static var _pool = new Pool<Rect>(Rect);

  public var ex:Float;
  public var ey:Float;
  public var width(get, set):Float;
  public var height(get, set):Float;
  public var min(get, null):Vector2;
  public var max(get, null):Vector2;
  public var pooled:Bool;

  public static inline function get(x:Float = 0, y:Float = 0, width:Float = 1, height:Float = 1):Rect {
    var rect = _pool.get();
    rect.set(x, y, width, height);
    rect.pooled = false;
    return rect;
  }

  public static function get_from_vectors(a:Vector2, b:Vector2):Rect {
    var rect = _pool.get();
    rect.set(Math.min(a.x, b.x), Math.min(a.y, b.y), Math.abs(b.x - a.x), Math.abs(b.y - a.y));
    rect.pooled = false;
    return rect;
  }

  function new() {
    super();
    ex = 0;
    ey = 0;
  }

  override function put() {
    if (!pooled) {
      pooled = true;
      _pool.putUnsafe(this);
    }
  }

  public inline function set(x:Float = 0, y:Float = 0, width:Float = 1, height:Float = 1):Rect {
    position.set(x, y);
    this.width = width;
    this.height = height;
    return this;
  }

  public inline function load(rect:Rect):Rect {
    position = rect.position;
    ex = rect.ex;
    ey = rect.ey;
    return this;
  }

  public function destroy() {}

  override inline function to_aabb(?rect:Rect):Rect return rect == null ? Rect.get(x, y, width, height) : rect.set(x, y, width, height);

  override inline function draw_debug(dg:Graphics, x:Float = 0, y:Float = 0):Void dg.drawRect(left + x, top + y, width, height);

  override inline function clone():Rect return Rect.get(x, y, width, height);

  override inline function contains(p:Vector2):Bool return this.rect_contains(p);

  override inline function intersects(l:Line):Null<IntersectionData> return this.rect_intersects(l);

  override inline function overlaps(s:Shape):Bool return s.collides(this) != null;

  override inline function collides(s:Shape):Null<CollisionData> return s.collide_rect(this);

  override inline function collide_rect(r:Rect):Null<CollisionData> return r.rect_and_rect(this);

  override inline function collide_circle(c:Circle):Null<CollisionData> return this.rect_and_circle(c);

  // getters
  static function get_pool():IPool<Rect> return _pool;

  inline function get_width():Float return ex * 2;

  inline function get_height():Float return ey * 2;

  function get_min():Vector2 return new Vector2(left, top);

  function get_max():Vector2 return new Vector2(bottom, right);

  override inline function get_top():Float return y - ey;

  override inline function get_bottom():Float return y + ey;

  override inline function get_left():Float return x - ex;

  override inline function get_right():Float return x + ex;

  // setters
  inline function set_width(value:Float):Float {
    ex = value * 0.5;
    return value;
  }

  inline function set_height(value:Float):Float {
    ey = value * 0.5;
    return value;
  }
}
