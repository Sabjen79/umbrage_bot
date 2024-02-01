abstract class LexiconVariable {
  String keyword;
  String name;
  String description;
  int color;

  LexiconVariable(this.keyword, this.name, this.description, this.color);

  String getValue();
}