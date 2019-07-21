//
//  ViewControllerTests.swift
//  WordGameTests
//
//  Created by Tarun Gorre on 19.07.19.
//  Copyright © 2019 Tarun Gorre. All rights reserved.
//

import XCTest
@testable import WordGame

class ViewControllerTests: XCTestCase {
    var allWords: [WordModel] = []
    var allSpanishWords: [String] = []

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "words", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return
        }
        
        guard let jsonResults = try? JSONDecoder().decode([WordModel].self, from: data) else {
            return
        }
        
        allWords = jsonResults

        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testFetchTheWords() {
        let promise = expectation(description: "Completion handler invoked")
        
        JsonParser.fetchTheWords { allWords in
            XCTAssertNotNil(allWords)
            promise.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testCollectAllSpaWords() {
        allSpanishWords = ["escuela primaria", "profesor / profesora", "alumno / alumna", "vacaciones ", "curso", "timbre", "grupo", "cuaderno", "quieto", "responder", "director del colegio / directora del colegio", "colegio público", "colegio privado", "autobús escolar", "jugarreta", "pareja", "ejercicio", "fiambrera", "ordenado", "motivado", "balón", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo", "campo", "rural", "colina", "valle", "granja", "campo", "laguna", "bosque", "seto", "selva lluviosa", "zona tropical", "vegetación", "rama", "parásito", "especie", "jungla", "ecuador", "espeso", "húmedo", "precipitación ", "suelo del bosque", "zona pantanosa", "edificio", "casa", "estación", "castillo", "edificio alto", "hospital", "ayuntamiento", "iglesia", "fábrica", "construir", "almacén", "puesto de bomberos", "urgencia", "problema", "ambulancia", "cuerpo de bomberos", "incendio", "bombero", "peligroso", "escalera", "accidente", "curioso", "urgente", "salvar", "océano", "mar", "ola", "playa", "roca", "alga", "isla", "nadar", "bistec", "salchicha", "pescado", "grasa", "magro", "hacer una barbacoa", "crustáceo", "cordero", "filete", "ala", "marisco", "carne picada", "salami", "tierno", "seguro", "unidad", "médico", "salvar", "bar", "café", "brindar", "salud", "por favor", "ronda", "barman ", "ruidoso", "atender", "gracias", "cacahuete", "hora feliz", "borracho", "echar", "sin alcohol", "pobreza", "delito", "ilegal", "crisis", "hambre", "violencia", "víctima", "cortina", "alfombra", "espejo", "lámpara", "imagen", "reloj", "acogedor", "colgar", "florero", "cojín", "política", "país", "democracia", "canario", "pingüino", "huevo", "nido", "corneja", "ala", "gorrión", "loro", "lechuza", "águila", "cisne", "pie", "mano", "brazo", "cabeza", "dedo", "ojos", "cara", "pierna", "cuerpo", "boca", "nariz", "rodilla", "oreja", "diente", "cuello", "espalda", "barriga", "liebre", "oso", "lobo", "cocodrilo", "canguro", "serpiente", "rana", "ardilla", "armadillo", "perezoso", "hipopótamo", "jirafa", "cazador/a", "corzo", "manso", "cereal", "arroz", "trigo", "maíz", "pasta", "vajilla", "plato", "cuchillo", "tenedor", "cuchara", "vaso", "sopera", "cucharilla", "taza", "botella", "cubertería", "bandeja", "palillos para comer", "platillo", "mantel", "cubierto", "porcelana", "literatura", "libro", "página", "historia", "poema", "cuento", "libro de bolsillo", "bellas letras", "largo", "leer", "clásico", "novela", "género", "complicado", "danza", "presentación", "ballet", "salón de baile", "pareja", "vals", "swing", "bailarín / bailarina", "moderno", "bailar", "emoción", "humor", "feliz", "triste", "emocionado", "alegría", "amor", "odio", "enfadado", "sentirse", "sentimiento", "esperanza", "deprimido", "compasión", "solo", "satisfecho", "orgulloso", "decepcionado", "indignado", "pintura", "fotografía", "galería", "foto", "artista", "pintar", "blanco y negro", "dibujo", "marco", "colgar", "retrato", "paisaje", "abstracto", "acuarela", "óleo", "película", "pincel", "copia", "arte contemporáneo", "artístico", "edad adulta", "adulto / adulta", "mujer", "hombre", "trabajar", "plan", "experiencia", "casarse", "enamorado", "parientes", "abuela", "abuelo", "nieto", "nieta", "sobrino", "sobrina", "pariente", "tía", "tío", "primo / prima", "suegros", "bisabuelos", "descendiente", "antepasado", "lejano", "primo de segundo grado ", "juego", "juego de paciencia", "carta", "dado", "regla", "ajedrez", "crucigrama", "puzzle"]
        XCTAssertEqual(allWords.map({$0.wordSpa}), allSpanishWords)
        
    }
    
    
    func testgetRandomEngWord() {
       guard let randomEngWord = allWords.randomElement()?.wordEng else { return }
        XCTAssertNotNil(randomEngWord)
    }
    
    func testTranslateSpaToEnglish() {
        let spanishWord = "escuela primaria"
        
        let englishWordObject = allWords.filter({$0.wordSpa == spanishWord}).first
        XCTAssertEqual(englishWordObject!.wordEng, "primary school")
        XCTAssertNotNil(englishWordObject)
    }
    
    func testTranslateEngToSpanish() {
        let englishWord = "primary school"
        
        let spanishWordObject = allWords.filter({$0.wordEng == englishWord}).first
        XCTAssertEqual(spanishWordObject!.wordSpa, "escuela primaria")
        XCTAssertNotNil(spanishWordObject)
    }

    func testValidateCorrectness() {
        
        let spanishWord = "escuela primaria"
        let englishWord = "primary school"
        let translatedSpaWord = allWords.filter({$0.wordEng == englishWord}).first?.wordSpa == spanishWord
        
        XCTAssertNotNil(spanishWord)
        XCTAssertNotNil(englishWord)
        XCTAssertTrue(translatedSpaWord)

        
    }
    
    func testValidateCorrectnessForWrongAnswer() {
        
        let spanishWord = "Jahre"
        let englishWord = "primary school"
        let translatedSpaWord = allWords.filter({$0.wordEng == englishWord}).first?.wordSpa == spanishWord
        
        XCTAssertNotNil(spanishWord)
        XCTAssertNotNil(englishWord)
        XCTAssertFalse(translatedSpaWord)
        
        
    }

    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
