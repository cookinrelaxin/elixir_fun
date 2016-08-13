defmodule Kv.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = Kv.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Kv.Bucket.get(bucket, "milk") == nil

    Kv.Bucket.put(bucket, "milk", 3)
    assert Kv.Bucket.get(bucket, "milk") == 3
  end

  test "deletes values by key", %{bucket: bucket} do
    assert Kv.Bucket.get(bucket, "milk") == nil

    Kv.Bucket.put(bucket, "milk", 3)
    assert Kv.Bucket.get(bucket, "milk") == 3

    Kv.Bucket.delete(bucket, "milk")
    assert Kv.Bucket.get(bucket, "milk") == nil
  end
    
end

