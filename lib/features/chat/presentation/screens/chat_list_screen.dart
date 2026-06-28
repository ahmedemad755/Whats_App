import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../router/app_router.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_list_tile.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text(
          'WhatsApp',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (_) {},
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'new_group', child: Text('New group')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'STATUS'),
            Tab(text: 'CHATS'),
            Tab(text: 'CALLS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const Center(child: Text('Status')),
          _ChatList(),
          const Center(child: Text('Calls')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.selectContact);
        },
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF25D366)),
          );
        }
        if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        }
        return ListView.separated(
          itemCount: state.chats.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            indent: 82,
            color: Colors.grey.shade200,
          ),
          itemBuilder: (context, index) {
            final chat = state.chats[index];
            return ChatListTile(
              chat: chat,
              onTap: () {
                final cubit = context.read<ChatCubit>();
                cubit.markAsRead(chat.id);
                Navigator.pushNamed(
                  context,
                  AppRoutes.chat,
                  arguments: {'chat': chat, 'cubit': cubit},
                );
              },
            );
          },
        );
      },
    );
  }
}
