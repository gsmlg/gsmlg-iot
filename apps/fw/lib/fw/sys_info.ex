defmodule Fw.SysInfo do
  def cpus do
  	System.schedulers
  end

  def netinfo do
  	case :os.type() do
      {:unix, :darwin} ->
        {addr, 0} = System.cmd("ifconfig", [])
        addr
      {:unix, :linux} ->
        {addr, 0} = System.cmd("ip", ["addr"])
        addr
  	end
  end
end