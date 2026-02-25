# Bilingui-AI (frontend Flutter)

Aplicativo mobile/web para aprendizado de idiomas com UI gamificada e tutor de IA. Este README foi escrito para quem lidera engenharia e precisa entender rapidamente o estado atual do front-end, como executá-lo e onde investir para produção.

<div align="center"> <img src="https://res.cloudinary.com/limpeja/image/upload/v1772037671/fef45d92-9d12-4408-817d-85b344d3d225.png" width="1024"> </div>



## Visão Rápida
- **Stack:** Flutter 3.4+, Dart 3, Riverpod 2, Dio, Material 3.
- **Plataformas alvo:** Web (Chrome) e dispositivos Flutter padrão.
- **Estado atual:** Protótipo visual completo; fluxos de autenticação, chat e voz estão mockados e não integram backend.
- **Pontos de atenção:** Base URL hardcoded em `lib/services/api_service.dart`, ausência de tratamento de erros/autenticação, strings sem i18n e sem testes automatizados.

## Como rodar
1) Instale Flutter 3.4+ (`flutter --version` para conferir).  
2) Na raiz, instale dependências: `flutter pub get`.  
3) Execute no Chrome (dev rápido): `flutter run -d chrome`.  
4) Formatação opcional antes de commits: `dart format lib test`.  
5) Lints: `flutter analyze`.  
6) Testes (ainda não existem): `flutter test`.

## Estrutura de pastas
- `lib/main.dart` – entrada do app, registra tema e `ProviderScope`.
- `lib/screens/` – telas (splash/auth, home, chat, voz, lições).
- `lib/widgets/` – componentes reutilizáveis (cartões, botões, animações).
- `lib/providers/` – estado global Riverpod (lições mockadas, stats, chat).
- `lib/services/api_service.dart` – cliente Dio com base URL fixa em `http://localhost:8000`.
- `lib/theme/` – tema Material 3 + tipografia Poppins.
- `assets/` – logo principal (registrado em `pubspec.yaml`).

## Fluxos principais (estado atual)
- **Shell & Splash:** `AppShell` anima splash e navega para Auth -> Home via timers locais.
- **Auth:** `AuthScreen` alterna login/cadastro apenas no cliente; após 2s chama callback `onLogin`. Não há validação, persistência ou tokens.
- **Home:** Navegação bottom nav controlada por `currentPageProvider`. Dashboard exibe progresso e lições mockadas de `lessonsProvider`.
- **Chat:** `ChatScreen` usa `chatMessagesProvider`; respostas de IA são geradas localmente por heurística e não chamam API.
- **Voz:** `VoicePracticeScreen` só alterna `isRecordingProvider`; não envia áudio.
- **Lições:** `LessonDetailScreen` usa passos estáticos e concede XP local via `userStatsProvider`.

## Convenções de engenharia
- **State management:** Riverpod (StateNotifier + Provider/StateProvider). Prefira novos estados em providers, evitando `setState` para dados compartilhados.
- **Temas:** Utilize `BilinguiTheme.lightTheme` e cores em `BilinguiColors`; tipografia via `AppFonts.poppins`.
- **Rede:** Centralize chamadas no `ApiService`. (TODO: extrair baseUrl para `--dart-define API_BASE_URL` e adicionar interceptors com auth/logging).
- **Nomenclatura:** Arquivos snake_case; widgets stateless sempre que possível; animações com `TickerProviderStateMixin`.

## Qualidade e segurança (gaps atuais)
- Sem autenticação real, gerenciamento de sessão ou armazenamento seguro.
- Chamadas de API inexistentes na UI; falta tratamento de exceções/timeout e indicadores de erro.
- Strings hardcoded em EN/PT, sem `intl`/localização.
- Sem testes (unit/widget/golden) e sem pipeline de CI configurado.
- Encoding incorreto em alguns textos (ex.: `"NÃ£o tem uma conta?"`, emoji corrompido) — salvar arquivos como UTF-8 corrige.
- Assets remotos para bandeiras (`Image.network`) podem quebrar offline; considerar assets locais ou cache.

## Passos recomendados para produção
1) **API & Auth:** Integrar `ApiService` aos fluxos de chat/voz/auth; mover baseUrl para `--dart-define`; adicionar headers de autenticação e retries limitados.  
2) **Estado & erros:** Tratar loading/error em providers; padronizar snackbars/dialogs de erro.  
3) **Internacionalização:** Introduzir `intl` e extrair todas as strings.  
4) **Acessibilidade:** Labels semânticos, contrastes e suporte a fontes escalonadas.  
5) **Testes:** Criar widget tests (navegação, providers) e goldens para componentes principais; rodar em CI.  
6) **Telemetria:** Adicionar analytics e rastreamento de falhas (ex.: Sentry/Firebase Crashlytics) com opt-in.  
7) **Performance Web:** Evitar `Image.network` sem cache, habilitar `--web-renderer canvaskit` para gráficos complexos.  
8) **Segurança:** Usar HTTPS, validar certificados, sanitizar entradas de chat/voz, limitar tamanho de upload.  
9) **Builds:** Configurar flavors (`dev`, `stg`, `prod`) com ícones/nomes distintos e scripts de build.

## Troubleshooting rápido
- **Erro de CORS no chat/voz:** certifique-se de que o backend (porta 8000 por padrão) está com CORS liberado para `http://localhost:...`.  
- **Fonte Poppins não aparece:** garanta cache do Google Fonts ou inclua a fonte localmente.  
- **Layout quebrado em telas menores:** verifique `SingleChildScrollView` e restrições em `AuthScreen`; priorize `LayoutBuilder` para responsividade web.

## Roadmap técnico (sugestão)
- Implementar pipeline CI (lint + test + build web) no GitHub Actions.
- Persistir progresso/XP e mensagens via backend ou storage local.
- Suporte offline básico (cache de lições) e modo baixo consumo de dados.
- Substituir dados mockados por responses reais e normalização de modelos.
- Adicionar camada de design tokens e documentação de componentes.

## Licença
Projeto fechado/interno. Defina política de licenciamento antes de distribuição.
