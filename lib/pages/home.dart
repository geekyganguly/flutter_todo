import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'package:todo/models.dart';
import 'package:todo/services.dart';
import 'package:todo/constants.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  final List<TodoModel> _todos = [];
  final List<Map<String, dynamic>> _filters = [
    {'key': TodoStatus.pending, 'title': 'Pending'},
    {'key': TodoStatus.completed, 'title': 'Completed'},
  ];
  TodoStatus _selectedFilter = TodoStatus.pending;

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  void _getTodos() async {
    setState(() {
      _loading = true;
    });

    List<TodoModel> todos = await TodoService().getTodos(_selectedFilter);

    setState(() {
      _todos.clear();
      _todos.addAll(todos);
      _loading = false;
    });
  }

  void _addTodo(String newTodo) async {
    try {
      // add todo
      await TodoService().addTodo(newTodo);
      // reload todos
      _getTodos();
      // show snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$newTodo added.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong',
          ),
        ),
      );
    }
  }

  void _toggleStatus(TodoModel todo) async {
    try {
      // toggle status
      await TodoService().toggleStatusTodo(todo.id, !todo.isCompleted);
      // reload todos
      _getTodos();
      // show snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${todo.task} mark as ${todo.isCompleted ? 'pending' : 'completed'}.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong',
          ),
        ),
      );
    }
  }

  void _removeTodo(TodoModel todo) async {
    try {
      // remove todo
      await TodoService().removeTodo(todo.id);
      // reload todos
      _getTodos();
      // show  snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${todo.task} removed.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong',
          ),
        ),
      );
    }
  }

  void _addTodoDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String newTodo = '';

          return AlertDialog(
            title: const Text('Add New Task'),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) {
                newTodo = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (newTodo.isEmpty) return;

                  _addTodo(newTodo);
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = AdaptiveTheme.of(context).mode.isDark;

    return AnimatedTheme(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Center(
            child: Text('Todo'),
          ),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                if (isDark) {
                  AdaptiveTheme.of(context).setLight();
                } else {
                  AdaptiveTheme.of(context).setDark();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                AuthService().logout();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 12,
                  children: List.from(_filters.map((filter) => ChoiceChip(
                        label: Text(filter['title']),
                        selected: _selectedFilter == filter['key'],
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedFilter =
                                selected ? filter['key'] : _selectedFilter;
                          });
                          if (selected) _getTodos();
                        },
                      ))),
                ),
              ),
              const Divider(height: 0),
              _loading
                  ? const LinearProgressIndicator()
                  : Expanded(
                      child: _todos.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage(
                                    isDark
                                        ? 'assets/empty_box_dark.png'
                                        : 'assets/empty_box_light.png',
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text('No Todo available'),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: _todos.length,
                              itemBuilder: (context, index) {
                                final todo = _todos[index];

                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        todo.task,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        DateFormat.yMEd()
                                            .format(todo.createdAt),
                                      ),
                                      trailing: Wrap(
                                        children: <Widget>[
                                          IconButton(
                                            icon: todo.isCompleted
                                                ? const Icon(
                                                    Icons.undo,
                                                    size: 20.0,
                                                  )
                                                : const Icon(
                                                    Icons.check,
                                                    size: 20.0,
                                                  ),
                                            onPressed: () =>
                                                _toggleStatus(todo),
                                          ),
                                          // ],
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 20.0,
                                              color: Colors.red,
                                            ),
                                            onPressed: () => _removeTodo(todo),
                                          ),
                                        ],
                                      ),
                                      onTap: () {},
                                    ),
                                    const Divider(height: 0),
                                  ],
                                );
                              }),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addTodoDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
