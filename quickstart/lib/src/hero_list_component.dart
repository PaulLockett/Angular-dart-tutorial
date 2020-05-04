import 'package:angular/angular.dart';
import 'hero.dart';
import 'hero_service.dart';
import 'dart:async';
import 'package:angular_router/angular_router.dart';
import 'route_paths.dart';

@Component(
  selector: 'my-heroes',
  templateUrl: 'hero_list_component.html',
  styleUrls: ['hero_list_component.css'],
  directives: [coreDirectives],
  pipes: [commonPipes]
)
class HeroListComponent implements OnInit{
  final title = 'Tour of Heroes';
  List<Hero> heroes;
  Future<void> _getHeroes() async{
    heroes = await _heroService.getAll();
  }

  void ngOnInit() => _getHeroes() ;

  Hero selected;
  void onSelected(Hero hero) => selected = hero;

  final HeroService _heroService;
  final Router _router;
  HeroListComponent(this._heroService, this._router);

  String _heroUrl(int id) =>
      RoutePaths.hero.toUrl(parameters: {idParam: '$id'});

  Future<NavigationResult> gotoDetail() =>  _router.navigate(_heroUrl(selected.id));

  Future<void> add(String name) async {
    name = name.trim();
    if (name.isEmpty) return null;
    heroes.add(await _heroService.create(name));
    selected = null;
  }

  Future<void> delete(Hero hero) async {
    await _heroService.delete(hero.id);
    heroes.remove(hero);
    if (selected == hero) selected = null;
  }
}
