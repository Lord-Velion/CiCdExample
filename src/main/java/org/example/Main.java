package org.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {
        String fileName = "output.txt";
        String content = "Хуйло\n";

        try {
            // Получаем путь к корню проекта
            Path projectRoot = Paths.get("").toAbsolutePath();
            Path filePath = projectRoot.resolve(fileName);

            // Записываем содержимое в файл
            Files.write(filePath, content.getBytes());

            System.out.println("Файл успешно создан: " + filePath);
        } catch (IOException e) {
            System.err.println("Ошибка при создании файла: " + e.getMessage());
        }
    }
}