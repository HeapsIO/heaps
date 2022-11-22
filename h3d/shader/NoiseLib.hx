package h3d.shader;

class NoiseLib extends hxsl.Shader {

static var SRC = {

//
// vec3  psrdnoise(vec2 pos, vec2 per, float rot)
// vec3  psdnoise(vec2 pos, vec2 per)
// float psrnoise(vec2 pos, vec2 per, float rot)
// float psnoise(vec2 pos, vec2 per)
// vec3  srdnoise(vec2 pos, float rot)
// vec3  sdnoise(vec2 pos)
// float srnoise(vec2 pos, float rot)
// float snoise(vec2 pos)
//
// Periodic (tiling) 2-D simplex noise (hexagonal lattice gradient noise)
// with rotating gradients and analytic derivatives.
// Variants also without the derivative (no "d" in the name), without
// the tiling property (no "p" in the name) and without the rotating
// gradients (no "r" in the name).
//
// This is (yet) another variation on simplex noise. It's similar to the
// version presented by Ken Perlin, but the grid is axis-aligned and
// slightly stretched in the y direction to permit rectangular tiling.
//
// The noise can be made to tile seamlessly to any integer period in x and
// any even integer period in y. Odd periods may be specified for y, but
// then the actual tiling period will be twice that number.
//
// The rotating gradients give the appearance of a swirling motion, and can
// serve a similar purpose for animation as motion along z in 3-D noise.
// The rotating gradients in conjunction with the analytic derivatives
// can make "flow noise" effects as presented by Perlin and Neyret.
//
// vec3 {p}s{r}dnoise(vec2 pos {, vec2 per} {, float rot})
// "pos" is the input (x,y) coordinate
// "per" is the x and y period, where per.x is a positive integer
//    and per.y is a positive even integer
// "rot" is the angle to rotate the gradients (any float value,
//    where 0.0 is no rotation and 1.0 is one full turn)
// The first component of the 3-element return vector is the noise value.
// The second and third components are the x and y partial derivatives.
//
// float {p}s{r}noise(vec2 pos {, vec2 per} {, float rot})
// "pos" is the input (x,y) coordinate
// "per" is the x and y period, where per.x is a positive integer
//    and per.y is a positive even integer
// "rot" is the angle to rotate the gradients (any float value,
//    where 0.0 is no rotation and 1.0 is one full turn)
// The return value is the noise value.
// Partial derivatives are not computed, making these functions faster.
//
// Author: Stefan Gustavson (stefan.gustavson@gmail.com)
// Version 2016-05-10.
//
// Many thanks to Ian McEwan of Ashima Arts for the
// idea of using a permutation polynomial.
//
// Copyright (c) 2016 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/stegu/webgl-noise
//

//
// TODO: One-pixel wide artefacts used to occur due to precision issues with
// the gradient indexing. This is specific to this variant of noise, because
// one axis of the simplex grid is perfectly aligned with the input x axis.
// The errors were rare, and they are now very unlikely to ever be visible
// after a quick fix was introduced: a small offset is added to the y coordinate.
// A proper fix would involve using round() instead of floor() in selected
// places, but the quick fix works fine.
// (If you run into problems with this, please let me know.)
//

// Modulo 289, optimizes to code without divisions
function mod289(x:Float) : Float {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

function mod289_3(x:Vec3) : Vec3 {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

var noiseSeed : Int;

// Permutation polynomial (ring size 289 = 17*17)
function permute(x:Float) : Float {
  return mod289((((x + noiseSeed * 67.)*34.0)+1.0)*x + noiseSeed*89.);
}

// Hashed 2-D gradients with an extra rotation.
// (The constant 0.0243902439 is 1/41)
function rgrad2(p:Vec2, rot:Float) : Vec2 {
// For more isotropic gradients, sin/cos can be used instead.
  var u = permute(permute(p.x) + p.y + noiseSeed) * 0.0243902439 + rot; // Rotate by shift
  u = fract(u) * 6.28318530718; // 2*pi
  return vec2(cos(u), sin(u));
}

//
// 2-D tiling simplex noise with rotating gradients and analytical derivative.
// The first component of the 3-element return vector is the noise value,
// and the second and third components are the x and y partial derivatives.
//
function psrdnoise(pos:Vec2,per:Vec2,rot:Float) : Vec3 {
  // Hack: offset y slightly to hide some rare artifacts
  pos.y += 0.01;
  // Skew to hexagonal grid
  var uv = vec2(pos.x + pos.y*0.5, pos.y);

  var i0 = floor(uv);
  var f0 = fract(uv);
  // Traversal order
  var i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);

  // Unskewed grid points in (x,y) space
  var p0 = vec2(i0.x - i0.y * 0.5, i0.y);
  var p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
  var p2 = vec2(p0.x + 0.5, p0.y + 1.0);

  // Integer grid point indices in (u,v) space
  i1 = i0 + i1;
  var i2 = i0 + vec2(1.0, 1.0);

  // Vectors in unskewed (x,y) coordinates from
  // each of the simplex corners to the evaluation point
  var d0 = pos - p0;
  var d1 = pos - p1;
  var d2 = pos - p2;

  // Wrap i0, i1 and i2 to the desired period before gradient hashing:
  // wrap points in (x,y), map to (u,v)
  var xw = mod(vec3(p0.x, p1.x, p2.x), per.x);
  var yw = mod(vec3(p0.y, p1.y, p2.y), per.y);
  var iuw = xw + 0.5 * yw;
  var ivw = yw;

  // Create gradients from indices
  var g0 = rgrad2(vec2(iuw.x, ivw.x), rot);
  var g1 = rgrad2(vec2(iuw.y, ivw.y), rot);
  var g2 = rgrad2(vec2(iuw.z, ivw.z), rot);

  // Gradients dot vectors to corresponding corners
  // (The derivatives of this are simply the gradients)
  var w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));

  // Radial weights from corners
  // 0.8 is the square of 2/sqrt(5), the distance from
  // a grid point to the nearest simplex boundary
  var t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));

  // Partial derivatives for analytical gradient computation
  var dtdx = -2.0 * vec3(d0.x, d1.x, d2.x);
  var dtdy = -2.0 * vec3(d0.y, d1.y, d2.y);

  // Set influence of each surflet to zero outside radius sqrt(0.8)
  if (t.x < 0.0) {
    dtdx.x = 0.0;
    dtdy.x = 0.0;
	t.x = 0.0;
  }
  if (t.y < 0.0) {
    dtdx.y = 0.0;
    dtdy.y = 0.0;
	t.y = 0.0;
  }
  if (t.z < 0.0) {
    dtdx.z = 0.0;
    dtdy.z = 0.0;
	t.z = 0.0;
  }

  // Fourth power of t (and third power for derivative)
  var t2 = t * t;
  var t4 = t2 * t2;
  var t3 = t2 * t;

  // Final noise value is:
  // sum of ((radial weights) times (gradient dot vector from corner))
  var n = dot(t4, w);

  // Final analytical derivative (gradient of a sum of scalar products)
  var dt0 = vec2(dtdx.x, dtdy.x) * 4.0 * t3.x;
  var dn0 = t4.x * g0 + dt0 * w.x;
  var dt1 = vec2(dtdx.y, dtdy.y) * 4.0 * t3.y;
  var dn1 = t4.y * g1 + dt1 * w.y;
  var dt2 = vec2(dtdx.z, dtdy.z) * 4.0 * t3.z;
  var dn2 = t4.z * g2 + dt2 * w.z;

  return 11.0*vec3(n, dn0 + dn1 + dn2);
}

//
// 2-D tiling simplex noise with fixed gradients
// and analytical derivative.
// This function is implemented as a wrapper to "psrdnoise",
// at the minimal cost of three extra additions.
//
function psdnoise(pos:Vec2, per:Vec2) : Vec3 {
  return psrdnoise(pos, per, 0.0);
}

//
// 2-D tiling simplex noise with rotating gradients,
// but without the analytical derivative.
//
function psrnoise(pos:Vec2, per:Vec2, rot:Float) : Float {
  // Offset y slightly to hide some rare artifacts
  pos.y += 0.001;
  // Skew to hexagonal grid
  var uv = vec2(pos.x + pos.y*0.5, pos.y);

  var i0 = floor(uv);
  var f0 = fract(uv);
  // Traversal order
  var i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);

  // Unskewed grid points in (x,y) space
  var p0 = vec2(i0.x - i0.y * 0.5, i0.y);
  var p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
  var p2 = vec2(p0.x + 0.5, p0.y + 1.0);

  // Integer grid point indices in (u,v) space
  i1 = i0 + i1;
  var i2 = i0 + vec2(1.0, 1.0);

  // Vectors in unskewed (x,y) coordinates from
  // each of the simplex corners to the evaluation point
  var d0 = pos - p0;
  var d1 = pos - p1;
  var d2 = pos - p2;

  // Wrap i0, i1 and i2 to the desired period before gradient hashing:
  // wrap points in (x,y), map to (u,v)
  var xw = mod(vec3(p0.x, p1.x, p2.x), per.x);
  var yw = mod(vec3(p0.y, p1.y, p2.y), per.y);
  var iuw = xw + 0.5 * yw;
  var ivw = yw;

  // Create gradients from indices
  var g0 = rgrad2(vec2(iuw.x, ivw.x), rot);
  var g1 = rgrad2(vec2(iuw.y, ivw.y), rot);
  var g2 = rgrad2(vec2(iuw.z, ivw.z), rot);

  // Gradients dot vectors to corresponding corners
  // (The derivatives of this are simply the gradients)
  var w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));

  // Radial weights from corners
  // 0.8 is the square of 2/sqrt(5), the distance from
  // a grid point to the nearest simplex boundary
  var t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));

  // Set influence of each surflet to zero outside radius sqrt(0.8)
  t = max(t, 0.0);

  // Fourth power of t
  var t2 = t * t;
  var t4 = t2 * t2;

  // Final noise value is:
  // sum of ((radial weights) times (gradient dot vector from corner))
  var n = dot(t4, w);

  // Rescale to cover the range [-1,1] reasonably well
  return 11.0*n;
}

//
// 2-D tiling simplex noise with fixed gradients,
// without the analytical derivative.
// This function is implemented as a wrapper to "psrnoise",
// at the minimal cost of three extra additions.
//
function psnoise(pos:Vec2, per:Vec2) : Float {
  return psrnoise(pos, per, 0.0);
}

//
// 2-D non-tiling simplex noise with rotating gradients and analytical derivative.
// The first component of the 3-element return vector is the noise value,
// and the second and third components are the x and y partial derivatives.
//
function srdnoise(pos:Vec2, rot:Float) : Vec3 {
  // Offset y slightly to hide some rare artifacts
  pos.y += 0.001;
  // Skew to hexagonal grid
  var uv = vec2(pos.x + pos.y*0.5, pos.y);

  var i0 = floor(uv);
  var f0 = fract(uv);
  // Traversal order
  var i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);

  // Unskewed grid points in (x,y) space
  var p0 = vec2(i0.x - i0.y * 0.5, i0.y);
  var p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
  var p2 = vec2(p0.x + 0.5, p0.y + 1.0);

  // Integer grid point indices in (u,v) space
  i1 = i0 + i1;
  var i2 = i0 + vec2(1.0, 1.0);

  // Vectors in unskewed (x,y) coordinates from
  // each of the simplex corners to the evaluation point
  var d0 = pos - p0;
  var d1 = pos - p1;
  var d2 = pos - p2;

  var x = vec3(p0.x, p1.x, p2.x);
  var y = vec3(p0.y, p1.y, p2.y);
  var iuw = x + 0.5 * y;
  var ivw = y;

  // Avoid precision issues in permutation
  iuw = mod289_3(iuw);
  ivw = mod289_3(ivw);

  // Create gradients from indices
  var g0 = rgrad2(vec2(iuw.x, ivw.x), rot);
  var g1 = rgrad2(vec2(iuw.y, ivw.y), rot);
  var g2 = rgrad2(vec2(iuw.z, ivw.z), rot);

  // Gradients dot vectors to corresponding corners
  // (The derivatives of this are simply the gradients)
  var w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));

  // Radial weights from corners
  // 0.8 is the square of 2/sqrt(5), the distance from
  // a grid point to the nearest simplex boundary
  var t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));

  // Partial derivatives for analytical gradient computation
  var dtdx = -2.0 * vec3(d0.x, d1.x, d2.x);
  var dtdy = -2.0 * vec3(d0.y, d1.y, d2.y);

  // Set influence of each surflet to zero outside radius sqrt(0.8)
  if (t.x < 0.0) {
    dtdx.x = 0.0;
    dtdy.x = 0.0;
	t.x = 0.0;
  }
  if (t.y < 0.0) {
    dtdx.y = 0.0;
    dtdy.y = 0.0;
	t.y = 0.0;
  }
  if (t.z < 0.0) {
    dtdx.z = 0.0;
    dtdy.z = 0.0;
	t.z = 0.0;
  }

  // Fourth power of t (and third power for derivative)
  var t2 = t * t;
  var t4 = t2 * t2;
  var t3 = t2 * t;

  // Final noise value is:
  // sum of ((radial weights) times (gradient dot vector from corner))
  var n = dot(t4, w);

  // Final analytical derivative (gradient of a sum of scalar products)
  var dt0 = vec2(dtdx.x, dtdy.x) * 4.0 * t3.x;
  var dn0 = t4.x * g0 + dt0 * w.x;
  var dt1 = vec2(dtdx.y, dtdy.y) * 4.0 * t3.y;
  var dn1 = t4.y * g1 + dt1 * w.y;
  var dt2 = vec2(dtdx.z, dtdy.z) * 4.0 * t3.z;
  var dn2 = t4.z * g2 + dt2 * w.z;

  return 11.0*vec3(n, dn0 + dn1 + dn2);
}

//
// 2-D non-tiling simplex noise with fixed gradients and analytical derivative.
// This function is implemented as a wrapper to "srdnoise",
// at the minimal cost of three extra additions.
//
function sdnoise(pos:Vec2) : Vec3 {
  return srdnoise(pos, 0.0);
}

//
// 2-D non-tiling simplex noise with rotating gradients,
// without the analytical derivative.
//
function srnoise(pos:Vec2, rot:Float) : Float {
  // Offset y slightly to hide some rare artifacts
  pos.y += 0.001;
  // Skew to hexagonal grid
  var uv = vec2(pos.x + pos.y*0.5, pos.y);

  var i0 = floor(uv);
  var f0 = fract(uv);
  // Traversal order
  var i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);

  // Unskewed grid points in (x,y) space
  var p0 = vec2(i0.x - i0.y * 0.5, i0.y);
  var p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
  var p2 = vec2(p0.x + 0.5, p0.y + 1.0);

  // Integer grid point indices in (u,v) space
  i1 = i0 + i1;
  var i2 = i0 + vec2(1.0, 1.0);

  // Vectors in unskewed (x,y) coordinates from
  // each of the simplex corners to the evaluation point
  var d0 = pos - p0;
  var d1 = pos - p1;
  var d2 = pos - p2;

  // Wrap i0, i1 and i2 to the desired period before gradient hashing:
  // wrap points in (x,y), map to (u,v)
  var x = vec3(p0.x, p1.x, p2.x);
  var y = vec3(p0.y, p1.y, p2.y);
  var iuw = x + 0.5 * y;
  var ivw = y;

  // Avoid precision issues in permutation
  iuw = mod289_3(iuw);
  ivw = mod289_3(ivw);

  // Create gradients from indices
  var g0 = rgrad2(vec2(iuw.x, ivw.x), rot);
  var g1 = rgrad2(vec2(iuw.y, ivw.y), rot);
  var g2 = rgrad2(vec2(iuw.z, ivw.z), rot);

  // Gradients dot vectors to corresponding corners
  // (The derivatives of this are simply the gradients)
  var w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));

  // Radial weights from corners
  // 0.8 is the square of 2/sqrt(5), the distance from
  // a grid point to the nearest simplex boundary
  var t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));

  // Set influence of each surflet to zero outside radius sqrt(0.8)
  t = max(t, 0.0);

  // Fourth power of t
  var t2 = t * t;
  var t4 = t2 * t2;

  // Final noise value is:
  // sum of ((radial weights) times (gradient dot vector from corner))
  var n = dot(t4, w);

  // Rescale to cover the range [-1,1] reasonably well
  return 11.0*n;
}

//
// 2-D non-tiling simplex noise with fixed gradients,
// without the analytical derivative.
// This function is implemented as a wrapper to "srnoise",
// at the minimal cost of three extra additions.
// Note: if this kind of noise is all you want, there are faster
// GLSL implementations of non-tiling simplex noise out there.
// This one is included mainly for completeness and compatibility
// with the other functions in the file.
//
function snoise(pos:Vec2) : Float {
  return srnoise(pos, 0.0);
}

}}