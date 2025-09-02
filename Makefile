-include .env

deploy-sepolia1: 
	@forge script script/Deploy.s.sol:DeploySimpleNft \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--private-key $(SEPOLIA_PRIVATE_KEY) \
		--broadcast \
		--verify \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		-vvvv
mint-sepolia1: 
	@forge script script/Interaction.s.sol:MintSimpleNFT --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast -vvvv
deploy-anvil1:
	@forge script script/DeployDynamic.s.sol:DeployDynamicNFT --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast  -vvvv
mintDy-anvil1:
	@forge script script/DynamicMintInteraction.s.sol:MintDynamicNFT --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast -vvvv

flip-anvil1:
	
	@forge script script/DynamicNFTflip.s.sol:FlipNFT --sig "run(uint256,uint256)" $(TOKEN_ID) $(MOOD) --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast -vvvv

mint-anvil1: 
	@forge script script/Interaction.s.sol:MintSimpleNFT --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast -vvvv