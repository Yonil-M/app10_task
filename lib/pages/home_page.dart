import 'package:app10_task/db/db_admin.dart';
import 'package:app10_task/models/task_model.dart';
import 'package:app10_task/pages/widgets/my_form_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  

  Future<String> getFullName()async{
    return "Yonil Mejia";
  }

  showDialogForm(){
    showDialog(
    context: context, 
    builder: (BuildContext context) {
      return MyFormWidget();
    }).then((value){
      print("El formulario fue cerrado");
      setState(() {
        
      });
    });
    
  }

  deleteTask(int taskId){
    DBAdmin.db.deleteTask(taskId).then((value){
      if(value>0){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: 
                  Row(children:const [
                    Icon(Icons.check_circle,color: Colors.white,),
                    SizedBox(height: 10.0,),
                    Text("Tarea eliminada")
                  ],))); 
      }
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task"),),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialogForm();
      },
      child: const Icon(Icons.add)),

      body: FutureBuilder(
        future:DBAdmin.db.getTask(),
        builder:(BuildContext context , AsyncSnapshot mapas) {
        if(mapas.hasData){
        List<TaskModel> myTask=mapas.data;
        return ListView.builder(
          itemCount: myTask.length,
          itemBuilder:(BuildContext context,int index) {
            return Dismissible(
              key: UniqueKey(),
              confirmDismiss: (DismissDirection direction)async {
                print(direction);
                return true;
                
              },
              direction: DismissDirection.horizontal,
              background: Container(color: Colors.redAccent),
              onDismissed: (DismissDirection direction) {
                deleteTask(myTask[index].id!);
              },
              child: ListTile(
                title: Text(myTask[index].title),
                subtitle: Text(myTask[index].description),
                trailing: IconButton(
                  onPressed: () {
                    showDialogForm();
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
            );
            
          },);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
        } ,

      )
    );
  }
}