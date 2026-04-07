# ABOUT
Checks connectivity from the hub cluster to the BMC interfaces of workload/spoke clusters as a pre-requisite for ZTP.

The script interacts with the RedFish API on the BMC.
Tested with:
- HPE iLO5

For the BMC addresses it can reach the Redfish API for it will scrape and report the following information via RedFish API:
- Serial Number
- Boot Mode
- Bios Version
- CPU count and Type
- Memory (GB)
- Number of disks
- Number of RAID volumes

# USE
1. Log into the appropriate Management cluster with `oc login`
2. On your CLI jumphost, clone this Git repo or pull the latest
3. Ensure the `bmc-check-creds` Secret in the `kustomization.yaml` for `<cluster-name>` is updated with the correct RedFish API credentials
3. Run the check for the desired site: `oc apply -k <cluster-name>`
4. Check the results via `oc logs` for the resulting pod.

## Example Output

### Non-working BMCs
```bash
SCRAPING NODE SUMMARY FOR REACHABLE BMC ADDRESSES

NODES NOT REACHABLE: IP.ADDR.1.1 IP.ADDR.1.2 IP.ADDR.1.3 IP.ADDR.1.4 IP.ADDR.1.5 IP.ADDR.1.6

NODES REACHABLE:

NODE SUMMARY (REACHABLE ONLY):
BMC  SERIAL  BOOTMODE  BIOSVERSION  CPU_COUNT  CPU_TYPE  MEM(GB)  DISKS  RAIDVOLUMES
```

### Working BMCs
```bash
SCRAPING NODE SUMMARY FOR REACHABLE BMC ADDRESSES
- PULLING FOR IP.ADDR.1.1
- PULLING FOR IP.ADDR.1.2
- PULLING FOR IP.ADDR.1.3
- PULLING FOR IP.ADDR.1.4
- PULLING FOR IP.ADDR.1.5
- PULLING FOR IP.ADDR.1.6
- PULLING FOR IP.ADDR.1.7

NODES NOT REACHABLE:

NODES REACHABLE: IP.ADDR.1.1 IP.ADDR.1.2 IP.ADDR.1.3 IP.ADDR.1.4 IP.ADDR.1.5 IP.ADDR.1.6 IP.ADDR.1.7

NODE SUMMARY (REACHABLE ONLY):
BMC            SERIAL      BOOTMODE  BIOSVERSION             CPU_COUNT  CPU_TYPE                                   MEM(GB)  DISKS  RAIDVOLUMES
IP.ADDR.1.1  SERIALNO  UEFI      U46 v1.76 (04/20/2023)  2          Intel(R) Xeon(R) Gold 6330N CPU @ 2.20GHz  512      4      0
IP.ADDR.1.2  SERIALNO  UEFI      U46 v1.76 (04/20/2023)  2          Intel(R) Xeon(R) Gold 6330N CPU @ 2.20GHz  512      4      0
IP.ADDR.1.3  SERIALNO  UEFI      U46 v1.76 (04/20/2023)  2          Intel(R) Xeon(R) Gold 6330N CPU @ 2.20GHz  512      4      0
IP.ADDR.1.4  SERIALNO  UEFI      U32 v2.80 (04/20/2023)  2          Intel(R) Xeon(R) Gold 6230R CPU @ 2.10GHz  384      2      0
IP.ADDR.1.5   SERIALNO  UEFI      U32 v2.80 (04/20/2023)  2          Intel(R) Xeon(R) Gold 6230R CPU @ 2.10GHz  384      2      0
IP.ADDR.1.6  SERIALNO  UEFI      U32 v2.80 (04/20/2023)  2          Intel(R) Xeon(R) Gold 6230R CPU @ 2.10GHz  384      2      0
IP.ADDR.1.7  SERIALNO  UEFI      U32 v2.80 (04/20/2023)  2          Intel(R) Xeon(R) Gold 6230R CPU @ 2.10GHz  384      2      0
```




# TODO
- Add Bios Config to report output. Already scraped as below.
    ```bash
    echo $THISSYSTEM | jq .Bios.Attributes
    ```
    Items of interest: BootMode,ConsistentDevNaming,IntelProcVtd,Numa,NvmeRaid,ProcHyperthreading,ProcTurbo,ProcVirtualization,Sriov,SubNumaClustering,TimeZone,WorkloadProfile

- Add MAC Address list per node. Example:
    ```bash
    THISETH=`curl https://${BMC}/redfish/v1/Systems/1/EthernetInterfaces?\$expand=.`
    THISMACS=`echo $THISETH | jq '.Members[] | .Id,.MACAddress'`
    ```

- Add Firmware info per node. Example:
    ```bash
    THISFIRMWARE=`curl https://${BMC}/redfish/v1/UpdateService/FirmwareInventory?\$expand=.`
    THISFIRMWAREINV=`echo $THISFIRMWARE | jq '.Members[] | .Name,.Version'`
    ```