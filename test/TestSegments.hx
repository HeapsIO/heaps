package test;

import h2d.col.Point;
import h2d.col.Segment;
import h2d.col.Segments;

class TestSegments {
    public function new() {}

    public function run() {
        testConvexContains();
        testConcaveContains();
        testDistanceAndProject();
    }

    function testConvexContains() {
        var p1 = new Point(0, 0);
        var p2 = new Point(0, 10);
        var p3 = new Point(10, 10);
        var p4 = new Point(10, 0);

        // For containsPoint(p, true) to succeed, the segments must be counter-clockwise
        // so that the point is on the inside side of all segment axes (s.side(p) >= 0).
        var ccw_s1 = new Segment(p1, p4);
        var ccw_s2 = new Segment(p4, p3);
        var ccw_s3 = new Segment(p3, p2);
        var ccw_s4 = new Segment(p2, p1);

        var ccw_segments:Segments = [ccw_s1, ccw_s2, ccw_s3, ccw_s4];

        Assert.isTrue(ccw_segments.containsPoint(new Point(5, 5), true));
        Assert.isFalse(ccw_segments.containsPoint(new Point(15, 5), true));
        Assert.isFalse(ccw_segments.containsPoint(new Point(-5, 5), true));
    }

    function testConcaveContains() {
        // Create an L-shaped concave polygon
        // Vertices: (0,0) -> (10,0) -> (10,5) -> (5,5) -> (5,10) -> (0,10) -> (0,0)
        var pts = [
            new Point(0, 0),
            new Point(10, 0),
            new Point(10, 5),
            new Point(5, 5),
            new Point(5, 10),
            new Point(0, 10)
        ];
        
        var segmentsList = [];
        var prev = pts[pts.length - 1];
        for (p in pts) {
            segmentsList.push(new Segment(prev, p));
            prev = p;
        }
        var segments:Segments = segmentsList;

        // Try containsPoint with isConvex = false.
        // This should run our implementation without throwing "TODO".
        try {
            var inside1 = segments.containsPoint(new Point(2, 2), false); // inside
            var inside2 = segments.containsPoint(new Point(8, 2), false); // inside
            var inside3 = segments.containsPoint(new Point(8, 8), false); // outside (in the hollow of the L)
            var inside4 = segments.containsPoint(new Point(2, 8), false); // inside
            var outside = segments.containsPoint(new Point(12, 12), false); // outside

            Assert.isTrue(inside1);
            Assert.isTrue(inside2);
            Assert.isFalse(inside3);
            Assert.isTrue(inside4);
            Assert.isFalse(outside);
        } catch (e:Dynamic) {
            Assert.isTrue(false);
            trace("Exception in containsPoint(..., false): " + e);
        }
    }

    function testDistanceAndProject() {
        var p1 = new Point(0, 0);
        var p2 = new Point(10, 0);
        var s = new Segment(p1, p2);
        var segments:Segments = [s];

        // test distance
        Assert.floatEquals(5.0, segments.distance(new Point(5, 5)));
        Assert.floatEquals(25.0, segments.distanceSq(new Point(5, 5)));

        // test project
        var proj = segments.project(new Point(5, 5));
        Assert.floatEquals(5.0, proj.x);
        Assert.floatEquals(0.0, proj.y);
    }
}
