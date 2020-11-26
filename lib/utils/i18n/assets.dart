const Map<String, String> enAssets = {
  'node.connecting': 'Connecting remote node...',
  'node.failed': 'Remote node connection failed',
  'transfer': 'Transfer',
  'receive': 'Receive',
  'copy': 'Copy',
  'address': 'Send to Address',
  'address.error': 'Invalid Address',
  'amount': 'Amount',
  'amount.error': 'Invalid amount',
  'amount.low': 'Insufficient balance',
  'amount.balance': 'Amount (Balance: {0})',
  'currency': 'Currency',
  'currency.select': 'Select Currency',
  'make': 'Make Transfer',
  'balance': 'Balance',
  'locked': 'Locked',
  'available': 'Available',
  'reserved': 'Reserved',
  'all': 'All',
  'in': 'In',
  'out': 'Out',
  'end': 'No More Data',
  'detail': 'Detail',
  'success': 'Success',
  'fail': 'Failed',
  'value': 'Value',
  'fee': 'Fee',
  'tip': 'Tip',
  'tip.tip':
      '\nAdding a tip to this Tx, paying\nthe block author for greater priority.\n',
  'from': 'From',
  'to': 'To',
  'block': 'Block',
  'event': 'Event ID',
  'hash': 'TxHash',
  'polkascan': 'Open in Browser',
  'claim.transaction': 'Claim Transaction',
  'topup': 'Top-Up',
  'withdraw': 'Withdraw',
  'lock': 'Lock',
  'signal': 'Signal',
  'claim.eligibility': 'Claim Eligibility',
  'rewards': 'Rewards',
  'approved': 'Approved',
  'pending': 'Pending',
  'rejected': 'Rejected',
  'signaled': 'Signaled',
  'staking': 'Staking',
  'total': 'Total',
  //lock takens
  'lock.tokens': 'Lock Tokens',
  'lock.start': 'Let\'s get started',
  'lock.instruction':
      'Locking tokens (MXC) places it in a DHX smart contract for safe keeping. During the lock period you will not have access to your tokens. When period is complete, your tokens will be available for you to claim back. You may claim rewards immediately after locking.',
  'lock.whatlocking': 'What is Locking?',
  'lock.howlock': 'How to lock tokens',
  'transaction.message': 'Transaction Message',
  'transaction.instruction':
      'Our smart contract categorizes your transaction based on the transaction message.',
  'formula': 'The Formula',
  'lock.duration': 'Lock Duration',
  'lock.more': 'Get to know more about locking',
  'amount.tokens': 'Amount of \nTokens',
  'public.key': 'DHX Public Key (hex)',
  'genesis.validator': 'Genesis Validator',
  'guide.public.key': 'Guide on how to create a public key',
  'your.transaction': 'Your Transaction Message',
  'expected': 'Expected',
  'your.convenience': 'For your convenience',
  'message.qrcode': 'Add my transaction message to the smart contract QR code',
  'check.message':
      'I understand I should always double check the transaction message',
  'back': 'Back',
  'agree': 'Agree',
  'understand': 'I understand',
  'send.token':
      'To lock, send your tokens from the wallet holding your tokens to this Smart Contract address',
  'guide.send': 'Guide on how to securely send to our official address',
  'gas.limit': 'Ethereum Gas Limit',
  'units': 'units',
  'gas.price': 'Suggested Gas Price',
  'gwei': 'Gwei',
  'lock.app': 'Lock',
  'click.instructions': 'Click for additional instructions',
  'guide.lock.app': 'Guide on how to lock tokens from outside the app',
  //signal tokens
  'signal.address': 'Signal Address',
  'signal.tokens': 'Signal Tokens',
  'signal.welcome': 'Welcome to Signaling',
  'signal.instruction':
      'Want to lock down tokens (DOT, MXC, IOTA) & mine DHX without the need to send tokens, but still gain the benefits?\n\nReceive mining benefits if your signalled tokens remain in your wallet for the duration of the signalling period. You may claim a portion of the rewards immediately after signalling.',
  'signal.instruction2':
      'To signal, send us a 0 ETH transaction from your token holding wallet along with a correct transaction message.',
  'signal.what': 'What is signaling',
  'signal.how': 'How to signal',
  'signal.warning': 'Warning: signaling IOTA requires extra care',
  'signal.how.iota': 'How to signal IOTA',
  'signal.signalling': 'Signalling',
  'signal.more': 'Get to know more about signalling',
  'signal.agree':
      'I have read, understood and agree with the above signalling instruction',
  'signal.important':
      'Important: Locking or signaling native tokens (DHX, DOT) requires at least 25-USD equivalent, whereas non-native tokens (MXC, IOTA) requires at least 50-USD equivalent.',
  'signal.send':
      'To signal, send us a transaction of 0 ETH from the wallet holding your tokens and a correct transaction message.',
  'signal.app': 'Signal',
  'signal.duration': 'Signal Duration',
  'guide.signal.app': 'Guide on how to signal tokens from outside the app',
  //Claim
  'claim.title': 'Claim',
  // 'claim.transaction': 'Claim Transaction',
  'claim.instruction': 'Only if you signal/lock outside of DataHighway app',
  'claim.hash': 'Signal or Locking Transaction Hash',
  'claim.which.chain': 'Which chain was the transaction on?',
  'claim.token.instruction': 'Token claims are handled as described in the ',
  'claim.dhx.document': 'DHX Documentation',
  'notify.receive': 'Token Received',
  'lock.address': 'Lock Address',
  'lock.locking': 'Locking',
  'lock.months': 'Months',
  'lock.democrac': 'via Democracy/Vote',
  'lock.phrelect': 'via Council/Vote',
  'lock.staking': 'via Staking/Bond',
  'lock.vesting': 'via Vesting',
  'lock.welcome': 'Welcome to Locking',
  'lock.agree':
      'I have read, understood and agree with the above locking instruction',
  'token.currency': 'Token Currency',
  'claim': 'Claim',
  'claim.agree': 'I Agree',
  'claim.terms': 'Terms and Conditions',
  'claim.terms.url': 'You can also find them at',
  'claim.eth.title': 'Enter the ETH address from the sale',
  'claim.eth': 'ETH address',
  'claim.eth.sign': 'Sign with your ETH address',
  'claim.eth.copy':
      'Click and copy the following string and sign it with the Ethereum account you used during the pre-sale in the wallet of your choice, using the string as the payload, and then paste the transaction signature object below:',
  'claim.amount': 'has a valid claim',
  'claim.empty': 'does not appear to have a valid claim.',
  'claim.empty2':
      'Please double check that you have signed the transaction correctly on the correct ETH account.',
  'genesis.true': 'True',
  'genesis.false': 'False',
  'transaction.qr': 'Add my transaction message to the wallet QR code',
  'transaction.double_check':
      '*Double check the transaction message, make sure your duration and amount is correct',
  'blockchain': 'Blockchain',
  'transaction.hash': 'Transaction Hash',
  'transaction.fee': 'Transaction Fee',
  'expected.msb': 'Expected MSB',
  'transaction.success':
      'You have been successfully claimed your transaction. It will be transferred to your account after contracted duration.',
  'duration': 'Duration',
  'timestamp': 'Timestamp',
  'your.claim': 'Your Claim',
  'signal.amount': 'Signal Amount',
  'sort.by': 'Sort By',
  'claim.history': 'Claim History',
  'transaction.filter': 'Filter with Transaction Message',
};

const Map<String, String> zhAssets = {
  'node.connecting': '正在连接远程节点...',
  'node.failed': '远程节点连接失败',
  'transfer': '转账',
  'receive': '收款',
  'copy': '复制',
  'address': '收款地址',
  'address.error': '无效地址',
  'amount': '数量',
  'amount.error': '格式错误',
  'amount.low': '余额不足',
  'amount.balance': '金额（余额：{0}）',
  'currency': '币种',
  'currency.select': '选择币种',
  'make': '添加转账',
  'balance': '余额',
  'locked': '锁定',
  'available': '可用',
  'reserved': '保留',
  'all': '全部',
  'in': '转入',
  'out': '转出',
  'end': '加载完毕',
  'detail': '详情',
  'success': '成功',
  'fail': '失败',
  'value': '金额',
  'fee': '手续费',
  'tip': '小费',
  'tip.tip': '\n为出块人支付额外的费用，\n可以提高交易打包优先级。\n',
  'from': '付款地址',
  'to': '收款地址',
  'block': '区块',
  'event': '交易ID',
  'hash': '交易Hash',
  'polkascan': '在浏览器中查看',
  'claim.transaction': '认领交易',
  'topup': '充值',
  'withdraw': '提取',
  'lock': '锁仓',
  'signal': '预锁仓',
  'claim.eligibility': '索回资格',
  'rewards': '奖励',
  'approved': '已通过',
  'pending': '待审核',
  'rejected': '已拒绝',
  'signaled': '已锁仓',
  'staking': '质押',
  'total': '总计',
  //lock takens
  'lock.tokens': '锁仓',
  'lock.start': '让我们开始吧',
  'lock.instruction':
      '锁仓(MXC) 将其置于一个 DHX 智能合约中，用于安全保存。在锁定期间，您将无法访问您的通证。 当锁定期结束时，您可以将通证领回。您可以在锁仓后立即领取奖励。',
  'lock.whatlocking': '什么是锁仓？',
  'lock.howlock': '如何锁定通证',
  'transaction.message': '交易消息',
  'transaction.instruction': '我们的智能合约根据交易消息哈希对您的操作进行分类。您必须非常认真地正确准备它。',
  'formula': '公式',
  'amount.tokens': '通证数量',
  'public.key': 'DHX公钥(hex)',
  'genesis.validator': '创世验证器',
  'guide.public.key': '如何创建一个公钥',
  'your.transaction': '您的交易哈希消息',
  'expected': '预期',
  'your.convenience': '为了您的便利',
  'message.qrcode': '将我的交易信息添加到钱包二维码',
  'check.message': '我理解我每次都应该检查交易消息',
  'agree': '同意',
  'understand': '我明白',
  'back': '返回',
  'send.token': '若要锁仓，从持有您的通证的钱包中将您的通证发送到这个智能合同地址。',
  'guide.send': '关于如何安全发送到我们的官方地址的指南',
  'gas.limit': '以太坊GAS燃料限制',
  'units': '单位',
  'gas.price': '建议的GAS燃料价格',
  'gwei': 'Gwei',
  'lock.app': '锁仓',
  'click.instructions': '点击以获取更多说明',
  'guide.lock.app': '有关如何从应用程序外部锁仓的指南',
  //signal tokens
  'signal.address': '信号地址',
  'signal.tokens': '预锁仓',
  'signal.welcome': '欢迎来到预锁仓',
  'signal.instruction':
      '是否想在无需发送令牌的情况下锁定令牌（DOT，MXC，IOTA）和DHX，但仍能获得好处？ 如果在信号通知期间内您的信号令牌仍留在您的钱包中，则可享受采矿收益。 发出信号后，您可以立即索取部分奖励。',
  'signal.instruction2': '要发出信号，请从您的代币持有钱包向我们发送0 ETH交易以及正确的交易消息。',
  'signal.what': '什么是预锁仓',
  'signal.how': '如何预锁仓',
  'signal.warning': '警告：预锁IOTA 需要额外的关注',
  'signal.how.iota': '如何预锁IOTA',
  'signal.signalling': '发信号',
  'signal.more': '了解有关信号的更多信息',
  'signal.agree': '我已阅读，理解并同意上述信令说明',
  'signal.important':
      '重要信息：锁仓或预锁原生通证(DHX, DOT) 至少需要25美元等值，而非原生通证(MXC, IOTA) 至少需要50美元等值',
  'signal.send': '预锁仓的方法是，从持有您的通证钱包中向我们发送0以太币的交易和正确的交易信息。',
  'signal.app': '预锁仓',
  'signal.duration': '信号持续时间',
  'guide.signal.app': '如何从应用程序外部预锁仓的指南',
  //Claim
  // 'claim.title': '认领',
  // 'claim.transaction': 'Claim Transaction',
  'claim.instruction': '仅当您在数据高速公路应用程序外面预锁仓/锁仓时',
  'claim.hash': '预锁仓或质押交易哈希',
  'claim.which.chain': '交易发生在哪个链？',
  'claim.token.instruction1': '通证领回要求按',
  'claim.dhx.document': 'DHX文件',
  'claim.token.instruction2': '中的描述处理',
  'notify.receive': '到账通知',
  'lock.address': '锁地址',
  'lock.democrac': '提案治理投票',
  'lock.phrelect': '议会选举投票',
  'lock.staking': '质押绑定',
  'lock.vesting': '投资锁定',
  'lock.welcome': '欢迎使用锁定',
  'lock.agree': '我已阅读，理解并同意以上锁定说明',
  'token.currency': '代币货币',
  'lock.duration': '锁定时间',
  'lock.locking': '锁定',
  'lock.months': '月数',
  'lock.more': '了解有关锁定的更多信息',
  'claim': '认领',
  'claim.agree': '同意',
  'claim.terms': '使用条款',
  'claim.terms.url': '您也可以通过链接查看原文',
  'claim.eth.title': '输入您参与售卖的以太坊地址',
  'claim.eth': '以太坊地址',
  'claim.eth.sign': '使用您的以太坊地址签名',
  'claim.eth.copy': '点击复制以下信息，并选择您常用的以太坊钱包将信息签名，然后将签名结果粘贴到下方的输入框中：',
  'claim.amount': '可认领代币',
  'claim.empty': '没有可以认领的代币。',
  'claim.empty2': '，请检查您的以太坊地址和签名信息。',
  'genesis.true': '真正',
  'genesis.false': '假',
  'transaction.qr': '将我的交易消息添加到钱包QR码',
  'transaction.double_check': '*仔细检查交易消息，确保您的时间和金额正确',
  'blockchain': '区块链',
  'transaction.hash': '交易哈希',
  'transaction.fee': '手续费',
  'expected.msb': '预期的MSB',
  'transaction.success': '您已成功声明您的交易。 在约定的期限后，它将转移到您的帐户中。',
  'duration': '持续时间',
  'timestamp': '时间戳记',
  'your.claim': '您的要求',
  'signal.amount': '信号量',
  'sort.by': '排序方式',
  'claim.history': '索赔历史',
  'transaction.filter': '过滤交易消息',
};
