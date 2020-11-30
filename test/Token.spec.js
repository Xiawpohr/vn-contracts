const { expect } = require('chai')

describe('Token', function () {
  const name = 'Test Token'
  const symbol = 'TST'

  before(async function () {
    this.Token = await ethers.getContractFactory('Token')
  })

  beforeEach(async function () {
    this.token = await this.Token.deploy(name, symbol)
    await this.token.deployed()
  })

  it('has name', async function () {
    expect(await this.token.name()).to.equal(name);
  })

  it('has a symbol', async function () {
    expect(await this.token.symbol()).to.equal(symbol);
  });

  it('has 18 decimals', async function () {
    expect(await this.token.decimals()).to.equal(18);
  });
})
