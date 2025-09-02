# DynamicNFT & Static (Foundry)

This project demonstrates two ERC-721 implementations with full test coverage and deployment scripts using **Foundry**:

- **StaticNFT**: A minimal NFT with baseURI management and sequential token IDs.
- **DynamicMoodNFT**: An on-chain SVG NFT that can switch between **HAPPY** and **SAD** states, controlled by the token owner or an approved address.

---

## Features

- ✅ **StaticNFT**

  - Sequential token IDs starting at 0
  - **Metadata hosted off-chain (IPFS)**, referenced via baseURI
  - Configurable baseURI
  - Minting restricted from minting to zero address
  - Ownable with baseURI updates
  - Includes **ERC721Burnable**

- ✅ **DynamicNFT**

  - Fully **on-chain metadata and SVG images** (Base64 encoded in `tokenURI`)
  - Default mood = `HAPPY`
  - Token owners/approved accounts can flip the mood to `SAD` or back
  - Custom **mint** and **burn** functions
  - Tracks **totalSupply**
  - Token metadata includes attributes reflecting current mood
  - Includes **ERC721Burnable**

- ✅ **Scripts**

  - `DeployStaticNFT.s.sol` – Deploys `StaticNFT`
  - `DeployDynamicMoodNFT.s.sol` – Deploys `DynamicMoodNFT`
  - `DynamicNFTFlip.s.sol` – Script to flip the mood of a DynamicMoodNFT
  - `InteractionSimple.s.sol` – Example interaction: mints a `StaticNFT`
  - `DynamicNFTMint.s.sol` – Example interaction: mints a `DynamicMoodNFT`

- ✅ **Tests**
  - 100% coverage across all contracts
  - Covers constructor logic, minting, burning, reverting conditions, access control, URI generation, totalSupply, and flipping mood
  - Systematic test implementation for **dynamic on-chain metadata URI checks** using helpers

---

## Requirements

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Solidity ^0.8.20
- OpenZeppelin Contracts v5.0.2

---

## Installation

````bash
# Clone repository
git clone https://github.com/wasim007choudhary/DynamicNFT-and-StaticNFT---Foundry
cd Dynamic-and-StaticNFT---Foundry


# Install dependencies
```bash
forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit
````

---

## 🔨 Build

```bash
forge build
```

## 🧪 Run Tests

```bash
forge test
```

# Run Coverage

```bash
# Run coverage
forge coverage --report lcov

# Optional: Generate HTML report
genhtml -o coverage-html lcov.info && open coverage-html/index.html
```

### Deployment

```bash
# Start local Anvil node
anvil


# Deploy StaticNFT  Local EnvironMent
	@forge script script/DeployStatic.s.sol:DeploySimpleNft --rpc-url $(YOUR_RPC_URL) --private-key $(YOUR_PRIVATE_KEY) --broadcast  -vvvv

# Deploy DynamicNFT Local EnvironMent
	@forge script script/DeployDynamic.s.sol:DeployDynamicNFT --rpc-url $(YOUR_RPC_URL) --private-key $(YOUR_PRIVATE_KEY) --broadcast  -vvvv
```

## 🔒 Security Notes

- Minting to zero address is prevented

- flipMood restricted to owner or approved addresses only

- Contracts use OpenZeppelin's battle-tested ERC721 and ERC721Burnable implementations

- Precise custom detailed errors and custom logics are implemented to ensure safety over the Openzeppelin Imports

## Contribution

Contributions are welcome! Please open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License.

Made with 🦾🧠⚙️ using Foundry and Solidity.

- yaml
- Copy
- Edit
