abstract class LexiconVariable {
  String keyword;
  String name;
  String description;
  String color;

  LexiconVariable(this.keyword, this.name, this.description, this.color);

  String getValue();
}