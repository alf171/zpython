class Animal:
    def __init__(self, name: str, sound: str) -> None:
        self.name = name
        self.sound = sound

    def speak(self) -> None:
        print(f"{self.name} says {self.sound}")

class Dog(Animal):
    def __init__(self, name: str) -> None:
        super().__init__(name, "woof")

    def speak(self) -> None:
        print("dog: ", end="")
        super().speak()


dog = Dog("remy")
dog.speak()
