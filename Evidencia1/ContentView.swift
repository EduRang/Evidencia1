import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool = false
}

struct MainTabView: View {
    var body: some View {
        TabView {
            CambiarFondoView()
                .tabItem {
                    Label("Fondo", systemImage: "paintbrush")
                }

            ExamenBeatboxView()
                .tabItem {
                    Label("Examen", systemImage: "questionmark.circle")
                }

            ListaTareasView()
                .tabItem {
                    Label("Tareas", systemImage: "checklist")
                }
        }
    }
}

struct CambiarFondoView: View {
    @State var edad = 0.0;
    @State var opacidad = 1.0;
    @State var fondo = false;
    @State var texto = "Cambiar texto";
    @State var controlTexto = false;
    @State var estilo = true;
    
    var body: some View {
        ZStack {
            if fondo {
                Color.red.brightness(0.60).ignoresSafeArea();
            }
            
            VStack {
                Button("Cambiar fondo"){
                    fondo = !fondo;
                }
                
                Button(texto){
                    controlTexto = !controlTexto;
                    if controlTexto {
                        texto = "Devolver texto"
                    } else {
                        texto = "Cambiar texto";
                    }
                }
                
                if estilo {
                    Button("Boton con estilo"){
                        estilo = !estilo;
                    }
                    .buttonStyle(BorderedButtonStyle())
                } else {
                    Button("Boton sin estilo"){
                        estilo = !estilo;
                    }
                    .buttonStyle(DefaultButtonStyle())
                }
                
                sliders
                
                images
            }
            .padding()
        }
    }
    
    var sliders: some View {
        VStack {
            Text("Edad: \(Int(edad))")
            Slider(value: $edad, in: 0...100, step: 1)
            
            Text("Opacidad: \(opacidad, specifier: "%.2f")")
            Slider(value: $opacidad, in: 0...1, step: 0.01)
        }
        .padding()
    }
    
    var images: some View {
        Image("ronaldinhosoccer")
            .resizable()
            .scaledToFit()
            .opacity(opacidad)
    }
}

struct ExamenBeatboxView: View {
    @State var num: Int = 1
    @State var showResult: Bool = false
    @State var score: Int = 0
    @State var selectedOption: String? = nil

    let questions: [(question: String, options: [String], correctAnswer: String)] = [
        ("Primer campeon mundial de Beatbox:", ["Skiller", "Dharni", "Thom Thum", "Roxorloops"], "Roxorloops"),
        ("Donde va a ser el proximo mundial de Beatbox:", ["EUA", "Francia", "Japon", "Polonia"], "Japon"),
        ("Actual campeon mundial:", ["Julard", "Tomazacre", "Dlow", "Napom"], "Julard"),
        ("Pais con mas titulos mundiales:", ["EUA", "Francia", "Corea del Sur", "Alemania"], "Francia"),
        ("Beatboxer con mas titulos mundiales:", ["Dharni", "River", "Alexinho", "Alem"], "Dharni"),
        ("", ["", "", "", ""], ""),
    ]
    
    var body: some View {
        VStack {
            Text("EXAMEN DE BEATBOX")
                .font(.largeTitle)
                .padding()
            
            if num < questions.count {
                let currentQuestion = questions[num - 1]
                
                Text("Pregunta \(num)")
                    .font(.title)
                    .padding()
                
                Text(currentQuestion.question)
                    .padding()
                    .multilineTextAlignment(.center)
                
                ForEach(currentQuestion.options, id: \.self) { option in
                    Button(action: {
                        if selectedOption == nil {
                            selectedOption = option
                        }
                    }) {
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(option == selectedOption ? (option == currentQuestion.correctAnswer ? Color.green : Color.red) : (selectedOption != nil && option == currentQuestion.correctAnswer ? Color.green : Color.blue))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .disabled(selectedOption != nil)
                    }
                    .padding(.horizontal)
                }
                
                if selectedOption != nil {
                    Button(action: {
                        nextQuestion()
                    }) {
                        Text("Siguiente pregunta")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
            } else {
                Text("¡Examen terminado!")
                    .font(.title)
                    .padding()
                Text("¡Sacaste \(score)/5!")
                if score > 4 {
                    Text("¡Aprobaste!")
                } else {
                    Text("¡Reprobaste!")
                }
                
                Button(action: {
                    retry()
                }){
                    Text("Volver a hacer el examen")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private func nextQuestion() {
        if selectedOption == questions[num - 1].correctAnswer {
            score += 1
        }
        selectedOption = nil
        num += 1
    }
    
    private func retry() {
        num = 1
        score = 0
    }
}

struct ListaTareasView: View {
    @State var tasks: [Task] = [
        Task(name: "Casa: Lavar trastes"),
        Task(name: "Casa: Barrer"),
        Task(name: "Escuela: Hacer tarea"),
        Task(name: "Escuela: Estudiar")
    ]

    var body: some View {
        NavigationView {
            VStack {
                ForEach(categories, id: \.self) { category in
                    TextBox(taskType: category, tasks: $tasks)
                        .padding(.vertical, 4)
                }
                
                List {
                    ForEach($tasks) { $task in
                        HStack {
                            Button(action: {
                                task.isCompleted.toggle()
                            }) {
                                HStack {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .blue : .gray)
                                    
                                    Text(task.name)
                                        .foregroundColor(task.isCompleted ? .blue : .primary)
                                        .strikethrough(task.isCompleted, color: .blue)
                                    Spacer()
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                deleteTask(task)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle("Lista de Tareas")
                        #if os(iOS)
                        .navigationBarTitleDisplayMode(.inline)
                        #endif
        }
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
}

var categories = [
    "Casa", "Escuela"
]

struct TextBox: View {
    @State var taskDescription: String = ""
    var taskType: String
    @Binding var tasks: [Task]
    
    var body: some View {
        VStack {
            TextEditor(text: $taskDescription)
                .foregroundColor(.gray)
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1)
                )
                .padding(.horizontal, 12)
            Button("Agregar tarea de \(taskType)") {
                addTask()
            }
            .buttonStyle(.bordered)
            .tint(.blue)
        }
    }
    
    func addTask() {
        guard !taskDescription.isEmpty else { return }
        tasks.append(Task(name: "\(taskType): \(taskDescription)"))
        taskDescription = ""
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
