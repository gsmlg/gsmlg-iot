defmodule Fw.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fw.Supervisor]
    children =
      [
        # Children for all targets
        # Starts a worker by calling: Fw.Worker.start_link(arg)
        # {Fw.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    main_viewport_config = Application.get_env(:fw, :viewport)

    [
      # Children that only run on the host
      # Starts a worker by calling: Fw.Worker.start_link(arg)
      # {Fw.Worker, arg},
      {Scenic, viewports: [main_viewport_config]}
    ]
  end

  def children(_target) do
    main_viewport_config = Application.get_env(:fw, :viewport)

    [
      # Children for all targets except host
      # Starts a worker by calling: Fw.Worker.start_link(arg)
      # {Fw.Worker, arg},
      {Harald.Transport,
       namespace: :bt,
       adapter: {Harald.Transport.UART, device: "/dev/ttyAMA0", uart_opts: [speed: 115_200]}},
      {Scenic, viewports: [main_viewport_config]}
    ]
  end

  def target() do
    Application.get_env(:fw, :target)
  end
end
