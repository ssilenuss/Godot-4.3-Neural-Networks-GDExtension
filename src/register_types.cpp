
#include "register_types.h"

#include <gdextension_interface.h>

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

// #include "GDExtensionBind/layer.h"
// #include "GDExtensionBind/network.h"
// #include "GDExtensionBind/GDLayer.h"
#include "GDExtensionBind/GDnetwork.h"
#include "GDExtensionBind/population.h"

using namespace godot;

void initialize_neuralnetwork_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

	GDREGISTER_CLASS(Layer);
	GDREGISTER_CLASS(Network);
	GDREGISTER_CLASS(GDLayer);
	GDREGISTER_CLASS(GDNetwork);
	GDREGISTER_CLASS(GANetwork);
	GDREGISTER_CLASS(Population);
}

void uninitialize_neuralnetwork_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
}



extern "C" {

// Initialization.
GDExtensionBool GDE_EXPORT network_library_init(GDExtensionInterfaceGetProcAddress p_get_proc_address, const GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
	godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

	init_obj.register_initializer(initialize_neuralnetwork_module);
	init_obj.register_terminator(uninitialize_neuralnetwork_module);
	init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

	return init_obj.init();
}
}