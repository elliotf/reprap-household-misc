all: stls

define render_stl_template

stls: stl/$(1)

stl/$(1) : part/$(1).scad
	openscad-nightly --enable sort-stl -D debug=0 -m make -o $$@.stl $$^ && echo $$^ && notify-send "$$@ done"

.PHONY : stl/$(1)

endef

scads := $(foreach scad, $(wildcard part/*.scad),$(patsubst %.scad,%,$(notdir $(scad))))

$(foreach scad, $(scads), $(eval $(call render_stl_template,$(scad))))
