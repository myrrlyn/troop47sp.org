defmodule Troop47sp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Troop47spWeb.Telemetry,
      Troop47sp.Repo,
      {DNSCluster, query: Application.get_env(:troop47sp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Troop47sp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Troop47sp.Finch},
      # Start a worker by calling: Troop47sp.Worker.start_link(arg)
      # {Troop47sp.Worker, arg},
      # Start to serve requests, typically the last entry
      Troop47spWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Troop47sp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Troop47spWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
