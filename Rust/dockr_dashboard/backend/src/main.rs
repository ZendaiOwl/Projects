use backend::connect::Connect;
use backend::routes::route::get_routes;

#[tokio::main]
async fn main() {
    let client = Connect::new();
    warp::serve(get_routes(client)).run(([0, 0, 0, 0], 3969)).await;
}

/* Update Request Example
{
  "BlkioWeight": 300,
  "CpuShares": 512,
  "CpuPeriod": 100000,
  "CpuQuota": 50000,
  "CpuRealtimePeriod": 1000000,
  "CpuRealtimeRuntime": 10000,
  "CpusetCpus": "0,1",
  "CpusetMems": "0",
  "Memory": 314572800,
  "MemorySwap": 514288000,
  "MemoryReservation": 209715200,
  "RestartPolicy": {
    "MaximumRetryCount": 4,
    "Name": "on-failure"
  }
}
 */
