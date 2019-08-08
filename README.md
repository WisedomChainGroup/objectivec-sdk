# objectivec-sdk

# 方法说明

objectivec-sdk主要是提供给实现普通转账事务的构造，及孵化器相关的操作，对于RPC来说，提供若干的接口，对于客户端来说，需要提供若干的实现方法，如下所示：

## 一、 基本说明

1）、区块确认完成

通过事务的哈希值查询确认区块数，并且确认是否已经完成，
我们认为往后确定2区块即可表示已经完成。
无论什么事务，都要等待至少2个区块确认才算完成

2）、返回格式
```
##### {"message":"","data":[],"statusCode":int}
* message：描述
* data   ：数据
* statusCode：      
   
{
    2000 正确
    2100 已确认
    2200 未确认
    5000 错误
    6000 格式错误
    7000 校验错误
    8000 异常
}
```
## 二、 JAVA-SDK文档

##### 下载Release里最新的sdk-php.rar，运行server-0.0.1-SNAPSHOT.jar :java -jar server-0.0.1-SNAPSHOT.jar --server.port="your port" --nodeNet="your node";
##### 所有的调用均为普通rpc
##### Content-Type: application/json;charset=UTF-8
1.0 生成keystore文件
```
* fromPassword(GET)
* 参数：
* 1）、password(String)
* 返回类型：json
* 返回值：
* {"message":"","data":[],"statusCode":int}
* data：keystore
```

1.1 地址校验
```
* verifyAddress(GET)
* 参数：
* 1）、address(String)
* 返回类型：json
* 返回值：
* {"message":"","data":[],"statusCode":int}
```
1.2 通过地址获得公钥哈希(调用此方法之前请先校验地址合法性！(调用verifyAddress方法))
```
* addressToPubkeyHash(GET)
* 参数：
* 1）、address(String)
* 返回类型：json
* 返回值：
* {"message":"","data":[],"statusCode":int}
* data：pubkeyHash（十六进制字符串）
```
1.3 通过公钥哈希获得地址
```
* pubkeyHashToAddress(GET)
* 参数：
* 1）、pubkeyHash(String)
* 返回类型：json
* 返回值：
* {"message":"","data":[],"statusCode":int}
* data：pubkeyHash(十六进制字符串)
```
1.4 通过keystore获得地址
```
* keystoreToAddress(POST)
* 参数：
* 1）、keystoreJson(String)
* 2）、password(String)
* 返回类型：json
* 返回值：
* {"message":"","data":[],"statusCode":int}
* data：address(String)
```
1.5 通过keystore获得公钥哈希
```
* keystoreToPubkeyHash()
* 参数：
* 1)、keystoreJson(String)
* 2)、password(String)
* 返回类型：json
* 返回值：
* {"message":"","data":[],"statusCode":int}
* data：pubkeyHash(十六进制字符串)
```
1.6 通过keystore获得私钥
```
* obtainPrikey(POST)
* 参数：
* 1)、keystoreJson(String)
* 2)、password(String)
* 返回类型：json
* 返回值：
* {"message":"","data":[],"statusCode":int}
* data：privateKey(十六进制字符串)
```
1.7 通过keystore获得公钥
```
* keystoreToPubkey(POST)
* 参数：
* 1)、keystoreJson(String)
* 2)、password(String)
* 返回类型：json
* 返回值：
* {"message":"","data":[],"statusCode":int}
* data：pubkey(十六进制字符串)
```
1.8 修改KeyStore密码方法
```
* modifyPassword(POST)
* 参数：
* 1)、keystoreJson(String)
* 2）、password(String)
* 3）、newPassword(String)
* 返回类型：json
* 返回值：
* {"message":"","data":[],"statusCode":int}
* data：keystore(json)
```
1.9 发起原生转账申请
```
* CreateRawTransaction(POST)
* 参数：
* 1）、fromPubkey(十六进制字符串)
* 2）、toPubkeyHash(十六进制字符串)
* 3）、amount（BigDecimal)
* 4）、nonce(Long)
* 返回类型：Json
* 返回值：
* {
* data :traninfo(原生事务)
* (int)statusCode:int
* (String)message:Success/Error
* }
```
2.0 发起原生孵化申请
```
* CreateRawHatchTransaction(POST)
* 参数：
* 1）、fromPubkey(十六进制字符串)
* 2）、toPubkeyHash(十六进制字符串)
* 3）、amount（BigDecimal)
* 4）、sharepubkeyhash（十六进制字符串）
* 5）、hatchType（int 120 365）
* 6）、nonce(Long)
* 返回类型：Json
* 返回值：
* {
* data :traninfo(原生事务)
* (int)statusCode:int
* (String)message:Success/Error
* }
```

2.1 发起原生利息收益事务
```
* CreateRawProfitTransaction(POST)
* 参数：
* 1）、fromPubkey(十六进制字符串)
* 2）、toPubkeyHash(十六进制字符串)
* 3）、amount（BigDecimal)
* 4）、txid（孵化事务哈希）
* 5）、nonce(Long)
* 返回类型：Json
* 返回值：
* {
* data :traninfo(原生事务)
* (int)statusCode:int
* (String)message:Success/Error
* }
```

2.2 发起原生分享收益事务
```
* CreateRawShareProfitTransaction(POST)
* 参数：
* 1）、fromPubkey(十六进制字符串)
* 2）、toPubkeyHash(十六进制字符串)
* 3）、amount（BigDecimal)
* 4）、txid（孵化事务哈希）
* 5）、nonce(Long)
* 返回类型：Json
* 返回值：
* {
* data :traninfo(原生事务)
* (int)statusCode:int
* (String)message:Success/Error
* }
```

2.3 发起原生提取本金事务
```
* CreateRawHatchPrincipalTransaction(POST)
* 参数：
* 1）、fromPubkey(十六进制字符串)
* 2）、toPubkeyHash(十六进制字符串)
* 3）、amount（BigDecimal)
* 4）、txid（孵化事务哈希）
* 5）、nonce(Long)
* 返回类型：Json
* 返回值：
* {
* data :traninfo(原生事务)
* (int)statusCode:int
* (String)message:Success/Error
* }
```
* 注意，这里的成功或者失败，仅仅是指动作本身，真正看事务有没有最终成功，还需要通过事务哈希查询确认区块数
