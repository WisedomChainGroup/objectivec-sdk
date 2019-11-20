# APPSDK方法说明

APPSDK是提供给APP调用的方法，主要是提供给实现普通转账事务的构造，签名，发送以及孵化器相关的操作，对于RPC来说，提供若干的接口，对于客户端来说，需要提供若干的实现方法，如下所示：

## 1.0 基本说明

1）、区块确认完成

通过事务的哈希值查询确认区块数，并且确认是否已经完成，
我们认为往后确定2区块即可表示已经完成。
无论什么事务，都要等待至少2个区块确认才算完成

2）、返回格式
##### {"message":"","data":[],"statusCode":int}
* message：描述
* data   ：数据
* statusCode：      

## 2.0 JAVA-SDK文档

1.1 根据密码生成keystore
 ```
 WalletUtility.createKeyStoreFromPassword
 参数：
 1）、密码（String)
 返回类型：json
 返回值：keystore
 ```

1.2 地址校验
 ```
 AccountUtility.verifyAddress
 参数：
 1）、地址字符串（String)
 返回类型：int
 返回值：
 0（正常）
 -1（出错）地址前缀错误
 -2（出错）校验错误
 ```

 
1.3 通过地址获得公钥哈希
 ```
 AccountUtility.addressToPubkeyHash
 参数：
 1）、地址字符串（String)
 返回类型：String（十六进制字符串）
 返回值：pubkeyHash
 ```
 
 
1.4 通过公钥哈希获得地址
 ```
 AccountUtility.publickeyHashToAddress
 参数：
 1）、公钥哈希(String)
 返回类型：String
 返回值：Address
 ```

 
1.5 通过keystore获得地址
 ```
 WalletUtility.keyStoreToAddress
 参数：
 1）、keystore(String)
 2）、密码（String)
 返回类型：String
 返回值：Address
 ```

1.6 通过公钥获得公钥哈希
 ```
 AccountUtility.publicKeyToPublicKeyHash
 参数：
 1）、公钥 (String）
 返回类型：String
 返回值：PublicKeyHash
 ```
 
1.7 通过keystore获得公钥
 ```
 WalletUtility.keyStoreToPubKey
 参数：
 1）、keyJson(String)
 2）、密码 (String)
 返回类型：String（十六进制字符串）
 返回值：Pubkey
 ```
 
1.8 通过keystore获取公钥Hash
 ```
 WalletUtility.keyStoreToPubKeyHash
 参数：
 1）、keyJson(String)
 2）、密码(String)
 返回类型：String
 返回值：PubkeyHash
 ```
 
1.9 通过私钥获取公钥
 ```
 KeyStoreService.privateKeyToPublicKey
 参数：
 1）、私钥 (String)
 返回类型：String
 返回值：PublicKey
 ```
 
1.10 通过keyStore和密码获取私钥
 ```
 KeyStoreService.getprivateKey
 参数：
 1）、keysData(String)
 2）、密码(String)
 返回类型：String
 返回值：cipherPrivKey
 ```
 
1.11 通过keyStore 验证密码是否正确
 ```
 KeyStoreService.verifyPassword
 参数：
 1）、keyData（String）
 2）、密码（String）
 返回类型：Bool
 返回值：
 true 正确
 false 错误
 ```
 
