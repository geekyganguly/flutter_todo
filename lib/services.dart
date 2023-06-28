import 'package:supabase_flutter/supabase_flutter.dart';

import "models.dart";
import "constants.dart";

final supabase = Supabase.instance.client;

class TodoService {
  Future<List<TodoModel>> getTodos(TodoStatus status) async {
    var response = await supabase
        .from('todos')
        .select()
        .eq('is_completed', status == TodoStatus.completed ? true : false)
        .order('updated_at');

    return response.map<TodoModel>((e) => TodoModel.fromJson(e)).toList();
  }

  Future<void> addTodo(String task) async {
    return supabase.from('todos').insert({'task': task});
  }

  Future<void> toggleStatusTodo(int id, bool isCompleted) async {
    return supabase
        .from('todos')
        .update({'is_completed': isCompleted}).match({'id': id});
  }

  Future<void> removeTodo(int id) async {
    return supabase.from('todos').delete().match({'id': id});
  }
}

class AuthService {
  Session? getSession() {
    return supabase.auth.currentSession;
  }

  Future<AuthResponse> login(String email, String password) async {
    return supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signup(String email, String password) async {
    return supabase.auth.signUp(email: email, password: password);
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
