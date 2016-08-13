defmodule Kv.RegistryTest do
  use ExUnit.Case, async: true

  setup context do 
    {:ok, _} = Kv.Registry.start_link(context.test)
    {:ok, registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert Kv.Registry.lookup(registry, "shopping") == :error

    Kv.Registry.create(registry, "shopping")
    assert {:ok, bucket} = Kv.Registry.lookup(registry, "shopping")

    Kv.Bucket.put(bucket, "milk", 1)
    assert Kv.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    Kv.Registry.create(registry, "shopping")
    {:ok, bucket} = Kv.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)

    _ = Kv.Registry.create(registry, "bogus")

    assert Kv.Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    Kv.Registry.create(registry, "shopping")
    {:ok, bucket} = Kv.Registry.lookup(registry, "shopping")

    Process.exit(bucket, :shutdown)

    ref = Process.monitor(bucket)
    assert_receive {:DOWN, ^ref,_, _, _}

    _ = Kv.Registry.create(registry, "bogus")

    assert Kv.Registry.lookup(registry, "shopping") == :error
  end

end


