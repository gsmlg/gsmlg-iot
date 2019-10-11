use Mix.Config

config :fw, :viewport, %{
  name: :main_viewport,
  # default_scene: {Fw.Scene.Crosshair, nil},
  default_scene: {Fw.Scene.SysInfo, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :fw"]
    }
  ]
}
