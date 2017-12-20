# Please edit PREFIX and INSTALL_DIR to your needs.

BUNDLE = abGate.lv2
PREFIX ?= /usr
INSTALL_DIR ?= $(DESTDIR)$(PREFIX)/lib/lv2

CXX ?= g++

$(BUNDLE): manifest.ttl gate.ttl gate.so
	rm -rf $(BUNDLE)
	mkdir $(BUNDLE)
	cp $^ $(BUNDLE)

abGateQt/libabGateQt.so:
	cd abGateQt; qmake-qt4; make

gate.so: gate.cpp
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(CPPFLAGS) $(CFLAGS) -g -O3 -shared -fPIC -DPIC -Wl,--as-needed gate.cpp `pkg-config --cflags --libs lv2` -o gate.so

gate_gui.so: gate_gui.cpp main_window.cpp main_window.h knob.cpp knob.h toggle.cpp toggle.h preset_widget.cpp preset_widget.h presets.cpp presets.h preset.cpp preset.h gate_const.h plugin_configuration.h
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(CPPFLAGS) $(CFLAGS) -g -O3 -shared -fPIC -DPIC -Wl,--as-needed gate_gui.cpp main_window.cpp knob.cpp toggle.cpp preset_widget.cpp presets.cpp preset.cpp `pkg-config --cflags gtkmm-2.4 --libs lv2 gthread-2.0` -o gate_gui.so

all: $(BUNDLE)

install: $(BUNDLE)
	mkdir -p $(INSTALL_DIR)
	rm -rf $(INSTALL_DIR)/$(BUNDLE)
	cp -R $(BUNDLE) $(INSTALL_DIR)

clean:
	rm -rf $(BUNDLE) gate.so gate_gui.so; cd abGateQt; rm -rf libabGateQt.so; make clean; rm -rf Makefile
