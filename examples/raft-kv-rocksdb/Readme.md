
### Slowed down parameters



```rust
crates/openraft/src/config/config.rs

/// The minimum election timeout in milliseconds
    #[clap(long, default_value = "150")]
    #[clap(long, default_value = "3000")]
    pub election_timeout_min: u64,

    /// The maximum election timeout in milliseconds
    #[clap(long, default_value = "300")]
    #[clap(long, default_value = "4000")]
    pub election_timeout_max: u64,

    /// The heartbeat interval in milliseconds at which leaders will send heartbeats to followers
    #[clap(long, default_value = "50")]
    #[clap(long, default_value = "2000")]
    pub heartbeat_interval: u64,

    /// The timeout for sending then installing the last snapshot segment,
    /// in millisecond. It is also used as the timeout for sending a non-last segment, if `send_snapshot_timeout` is 0.
    #[clap(long, default_value = "200")]
    #[clap(long, default_value = "8000")]
    pub install_snapshot_timeout: u64,

    /// The timeout for sending a **non-last** snapshot segment, in milliseconds.
@@ -129,7 +129,7 @@ pub struct Config {
    /// The snapshot policy to use for a Raft node.
    #[clap(
        long,
        default_value = "since_last:5000",
        default_value = "since_last:50000",
        parse(try_from_str=parse_snapshot_policy)
    )]
    pub snapshot_policy: SnapshotPolicy
```

[Reference](https://github.com/stormasm/slor/commit/2fadf86b3616160830b7c1f4048a65e0459d99e5)
