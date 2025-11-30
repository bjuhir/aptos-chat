module gated_chat::gated_chat {
    use std::string::{Self, String};
    use std::vector;
    use std::signer;
    use aptos_framework::event;
    use aptos_framework::timestamp;
    use aptos_framework::account;

    /// Error codes
    const E_NOT_INITIALIZED: u64 = 1;
    const E_COMMUNITY_NOT_FOUND: u64 = 2;
    const E_NOT_MEMBER: u64 = 3;

    struct Channel has store, drop, copy {
        name: String,
    }

    struct Community has store {
        name: String,
        description: String,
        creator: address,
        gating_collection: String, // The collection name required to join
        members: vector<address>,
        channels: vector<Channel>,
    }

    struct AppStore has key {
        communities: vector<Community>,
    }

    #[event]
    struct MessageSent has drop, store {
        community_idx: u64,
        channel_idx: u64,
        sender: address,
        content: String,
        timestamp: u64,
    }

    #[event]
    struct CommunityCreated has drop, store {
        community_idx: u64,
        name: String,
        creator: address,
    }

    #[event]
    struct MemberJoined has drop, store {
        community_idx: u64,
        member: address,
    }

    /// Initialize the module
    fun init_module(account: &signer) {
        move_to(account, AppStore {
            communities: vector::empty(),
        });
    }

    /// Create a new community
    public entry fun create_community(
        creator: &signer,
        name: String,
        description: String,
        gating_collection: String
    ) acquires AppStore {
        let store = borrow_global_mut<AppStore>(@0x1);
        let creator_addr = signer::address_of(creator);

        let channels = vector::empty();
        vector::push_back(&mut channels, Channel { name: string::utf8(b"General") });

        let members = vector::empty();
        vector::push_back(&mut members, creator_addr); // Creator auto-joins

        let community = Community {
            name,
            description,
            creator: creator_addr,
            gating_collection,
            members,
            channels,
        };

        vector::push_back(&mut store.communities, community);
        let community_idx = vector::length(&store.communities) - 1;

        event::emit(CommunityCreated {
            community_idx,
            name,
            creator: creator_addr,
        });
    }

    /// Join a community
    /// Note: In a real app, we would verify NFT ownership here using `token::check_balance` 
    /// or similar. For this MVP, we will assume the frontend checks it, 
    /// or we can add a basic check if we import the Token standard.
    /// For now, we'll leave the verification logic as a TODO or basic check.
    public entry fun join_community(
        user: &signer,
        community_idx: u64
    ) acquires AppStore {
        let store = borrow_global_mut<AppStore>(@0x1);
        assert!(community_idx < vector::length(&store.communities), E_COMMUNITY_NOT_FOUND);

        let community = vector::borrow_mut(&mut store.communities, community_idx);
        let user_addr = signer::address_of(user);

        // Check if already member
        if (!vector::contains(&community.members, &user_addr)) {
            vector::push_back(&mut community.members, user_addr);
            event::emit(MemberJoined {
                community_idx,
                member: user_addr,
            });
        };
    }

    /// Send a message
    public entry fun send_message(
        user: &signer,
        community_idx: u64,
        channel_idx: u64,
        content: String
    ) acquires AppStore {
        let store = borrow_global_mut<AppStore>(@0x1);
        assert!(community_idx < vector::length(&store.communities), E_COMMUNITY_NOT_FOUND);

        let community = vector::borrow(&store.communities, community_idx);
        let user_addr = signer::address_of(user);

        // Verify membership
        assert!(vector::contains(&community.members, &user_addr), E_NOT_MEMBER);
        
        // Verify channel exists
        assert!(channel_idx < vector::length(&community.channels), E_COMMUNITY_NOT_FOUND);

        event::emit(MessageSent {
            community_idx,
            channel_idx,
            sender: user_addr,
            content,
            timestamp: timestamp::now_seconds(),
        });
    }
}
