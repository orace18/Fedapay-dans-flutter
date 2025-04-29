//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <feda/feda_plugin_c_api.h>
#include <flash_api/flash_api_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FedaPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FedaPluginCApi"));
  FlashApiPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlashApiPluginCApi"));
}
