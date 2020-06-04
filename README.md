# APPSDK方法说明

APPSDK是提供给APP调用的方法，主要是提供给实现普通转账事务的构造，签名，发送，自定义资产，多签以及投票抵押等相关的操作，对于RPC来说，提供若干的接口，对于客户端来说，需要提供若干的实现方法，如下所示： 项目需引入第三方依赖库：TrustWallet pod 'TrustWalletCore', '~> 0.12.15'


## IOS-SDK文档

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
 
1.12 通过私钥进行签名操作
 ```
 Keycreat.sign
 参数：
 1）、签名内容（String）
 2）、私钥（String）
 返回类型：String
 返回值：签名后数据的hexString
 ```
 
1.13 验证签名是否正确
 ```
 Keycreat.verifySign
 参数：
 1）、签名后的数据（String）
 2）、PublicKey（String）
 3）、签名原文（String）
 返回类型：Bool
 返回值：
 true 正确
 false 错误
 ```
 
2.0 构造转账事务
 ```
 TradeUtility.clientToTransferAccount
 参数：
 1）、发送地址的公钥（String）
 2）、接受地址的公钥哈希（String）
 3）、私钥（String）
 4）、转账金额（String）
 5）、nonce（int）
 返回类型：String
 返回值：构造完成的转账事务
 ```
 
2.1 构造的投票事务
 ```
 TradeUtility.clientToTransferVote
 参数：
 1）、发送地址的公钥（String）
 2）、节点地址的公钥哈希（String）
 3）、私钥（String）
 4）、投票数量（String）
 5）、nonce（int）
 返回类型：String
 返回值：构造完成的投票事务
 ```
 
2.2 构造投票撤回事务
 ```
 TradeUtility.clientToTransferVoteWithdraw
 参数：
 1）、发送地址的公钥（String）
 2）、节点地址的公钥哈希（String）
 3）、私钥（String）
 4）、撤回数量（String）
 5）、nonce（int）
 6）、txid（事务哈希）（String）
 返回类型：String
 返回值：构造完成的撤回事务
 ```
 
2.3 构造抵押事务（申请矿工）
 ```
 TradeUtility.clientToTransferMortgage
 参数：
 1）、抵押地址的公钥（String）
 2）、抵押地址的公钥哈希（String）
 3）、私钥（String）
 4）、撤回数量（String）
 5）、nonce（int）
 返回类型：String
 返回值：构造完成的抵押事务
 ```
 
2.4 构造抵押撤回事务（取消节点）
 ```
 TradeUtility.clientToTransferMortgageWithdraw
 参数：
 1）、抵押地址的公钥（String）
 2）、抵押地址的公钥哈希（String）
 3）、私钥（String）
 4）、撤回数量（String）
 5）、nonce（int）
 6）、txid（事务哈希）（String）
 返回类型：String
 返回值：构造完成的抵押撤回事务
 ```
 
2.5 构造发行自定义资产事务
 ```
 TradeUtility.createSignToDeployforRuleAsset
 参数：
 1）、发送地址的公钥（String）
 2）、私钥（String）
 3）、nonce（int）
 4）、payload (Data）
 payload说明：数组进行RLP编码后的Data数据，数组元素包含（资产名String、发行量Long、总发行量Long、创建者公钥String、所有者公钥哈希String、是否允许增发Int、资产说明String）
 返回类型：String
 返回值：构造完成的发行自定义资产事务
 ```
 
2.6 构造自定义资产增发、所有权、转账事务
 ```
 TradeUtility.createSignToDeployforRuleTransfer
 参数：
 1）、发送地址的公钥（String）
 2）、私钥（String）
 3）、nonce（int）
 4）、类别（String）增发、所有权、转账 --> 02 00 01
 5）、资产哈希（String）
 6）、payload (Data）
 payload说明：数组进行RLP编码后的Data数据
 增发：数组元素包含（增发数量Long）
 所有权：数组元素包含（所有者地址的公钥哈希String）
 转账：数组元素包含（发送者公钥String、接收者公钥哈希String、转账金额Long）
 返回类型：String
 返回值：构造完成的自定义资产增发、所有权、转账事务
 ```
 
2.7 构造多签部署原文
 ```
 TradeUtility.clientToCreateMultiSign
 参数：
 1）、部署者地址的公钥（String）
 2）、私钥（String）
 3）、nonce（int）
 4）、payload (Data）
 payload说明：数组进行RLP编码后的Data数据，数组元素包含（资产哈希String、参与多签的地址数量Int、最小会签人数Int、空公钥数组Array、空签名数组Array、参与者地址公钥哈希数组Array）
 返回类型：String
 返回值：构造完成的多签部署原文
 ```
 
2.8 构造多签转账原文
 ```
 TradeUtility.clientToCreateMultiSignTransfer
 参数：
 1）、发送地址的公钥（String）
 2）、私钥（String）
 3）、nonce（int）
 4）、资产哈希（String）
 5）、payload (Data）
 payload说明：数组进行RLP编码后的Data数据，数组元素包含（发送地址类型0代表普通地址1代表多签地址Int、接收地址类型0代表普通地址1代表多签地址Int、空公钥数组Array、空签名数组Array、接收地址的公钥哈希String、转账金额Long、参与者地址公钥哈希数组Array）
 返回类型：String
 返回值：构造完成的多签转账原文
 ```
 
 2.9 构造多签发行代币及转账事务
 ```
 TradeUtility.multiSignerAffair
 参数：
 1）、事务类型Type（String）  发行07 转账08
 2）、nonce（int）
 3）、发送者公钥（String）
 4）、资产哈希（String）
 5）、私钥（String）
 6）、payloadType（String）  发行01 转账03
 7）、payload (Data）
 payload说明：数组进行RLP编码后的Data数据
 发行资产：数组元素包含（资产哈希String、参与多签的地址数量Int、最小会签人数Int、公钥数组Array、签名数组Array、参与者地址公钥哈希数组Array）
 多签转账：数组元素包含（发送地址类型0代表普通地址1代表多签地址Int、接收地址类型0代表普通地址1代表多签地址Int、公钥数组Array、签名数组Array、接收地址的公钥哈希String、转账金额Long、参与者地址公钥哈希数组Array）
 返回类型：String
 返回值：构造完成的多签发行代币及转账事务
 ```
 
 2.10 构造条件支付部署转入提取事务
 ```
 TradeUtility.CreateRateheightlockruleForDeploy
 参数：
 1）、事务类型Type（String）  部署07  转入08  提取08
 2）、nonce（int）
 3）、发送者公钥（String）
 4）、资产哈希（String）
 5）、私钥（String）
 6）、payloadType（String）  部署04  转入08  提取09
 7）、payload (Data）
 payload说明：数组进行RLP编码后的Data数据
 部署条件支付：数组元素包含（资产哈希String（WDC传20字节0）、转入资产倍数Long、间隔区块高度Int、资产提取比例String、接收地址公钥哈希String(不限定提取地址传20字节0)）
 转入资产：数组元素包含（转入金额Long）
 提取资产：数组元素包含（某笔转入事务哈希String、提取到的地址的公钥哈希String）
 返回类型：String
 返回值：构造完成的条件支付事务
 ```


