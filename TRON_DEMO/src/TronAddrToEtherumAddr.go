package main

import (
	"encoding/hex"
	"fmt"

	"github.com/btcsuite/btcutil/base58"
	"github.com/fbsobreira/gotron-sdk/pkg/address"
)

// HexToBase58 将十六进制地址转换为Base58地址
func ConvertAddress(hex_add string) address.Address {
	// 将字节数组转换为波场地址类型
	addr := address.HexToAddress(hex_add)
	return addr
}

func Hex_Address_To_Hex(hex_addr string) address.Address {
	addr := address.HexToAddress(hex_addr)
	return addr
}

func Base_Address_To_Hex(base_addr string) (string, error) {
	// Decode the TRON address from Base58
	tronAddressBytes := base58.Decode(base_addr)

	ethAddressBytes := tronAddressBytes[1:]

	// Convert the Ethereum address bytes to a hex string with '0x' prefix
	ethAddress := "0x" + hex.EncodeToString(ethAddressBytes)
	return ethAddress[:42], nil
}

func main() {
	base_addr := "TYfJeDpcWC6NcYiC6TrAceT5pQArYP1oM8"
	addr, _ := Base_Address_To_Hex(base_addr)
	fmt.Println(addr)
}
