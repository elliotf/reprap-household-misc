all: track_side tape_side knob 14cm_cut_jig 13cm_cut_jig 12cm_cut_jig

track_side:
	openscad-nightly -m make -o track_side.stl track_side.scad

tape_side:
	openscad-nightly -m make -o tape_side.stl tape_side.scad

knob:
	openscad-nightly -m make -o knob.stl knob.scad

14cm_cut_jig:
	openscad-nightly -m make -o 14cm_cut_jig.stl 14cm_cut_jig.scad

13cm_cut_jig:
	openscad-nightly -m make -o 13cm_cut_jig.stl 13cm_cut_jig.scad

12cm_cut_jig:
	openscad-nightly -m make -o 12cm_cut_jig.stl 12cm_cut_jig.scad

.PHONY : track_side tape_side knob 14cm_cut_jig 13cm_cut_jig 12cm_cut_jig
