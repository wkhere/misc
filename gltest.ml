
let _ =
    ignore( Glut.init Sys.argv );
    Glut.initDisplayMode ~double_buffer:true ();
    ignore (Glut.createWindow ~title:"OpenGL Demo");
    let render () =
      GlClear.clear [ `color ];
      GlMat.rotate ~angle:(Sys.time() *. 0.01) ~z:1. ();
      GlDraw.begins `triangles;
      List.iter GlDraw.vertex2 [-1., -1.; 0., 1.; 1., -1.];
      GlDraw.ends ();
      Glut.swapBuffers () in
    Glut.displayFunc ~cb:render;
    Glut.idleFunc ~cb:(Some Glut.postRedisplay);
    Glut.mainLoop ()
