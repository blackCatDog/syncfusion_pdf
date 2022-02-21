import 'dart:convert';
import 'dart:io';
import "dart:math";

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    ///测试地址   http://www.fhdq.net/
    ///不能识别符号_
    ///不能识别国家货币代码K、z
    ///少部分emoji不能被识别
    String str = "%^˙‥‧‵‵❝❞、。〃「」『』〝〞︰︰﹁﹂﹃﹄﹐﹒﹔﹔﹕！＃＄％＆＊，．：；？＠～…“‘·′”’";//中文标点符号
    String str4 = ", '\"~!@#\$%^&*()-=+{}<>?,.";//英文标点符号
    String str3 = "❤❥웃유♋☮✌☏☢☠✔☑♚▲♪✈✞÷↑↓◆◇⊙■□△▽¿─│♥❣♂♀☿Ⓐ✍✉☣☤✘☒♛▼♫⌘☪≈←→◈◎☉★☆⊿※¡━┃♡ღツ☼☁❅♒✎©®™Σ✪✯☭➳卐√↖↗●◐Θ◤◥︻〖〗┄┆℃℉°✿ϟ☃☂✄¢€£∞✫★½✡×↙↘○◑⊕◣◢︼【】┅┇☽☾✚〓▂▃▄▅▆▇█▉▊▋▌▍▎▏↔↕☽☾の•▸◂▴▾┈┊①②③④⑤⑥⑦⑧⑨⑩ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ㍿▓♨♛❖♓☪✙┉┋☹☺☻تヅツッシÜϡﭢ™";
    String str5 = "™℠℗©®♥❤❥❣❦❧♡۵웃유ღ♋♂♀☿☼☀☁☂☄☾☽❄☃☈⊙☉℃℉❅✺ϟ☇♤♧♡♢♠♣♥♦☜☞☝✍☚☛☟✌✽✾✿❁❃❋❀⚘☑✓✔√☐☒✗✘ㄨ✕✖✖⋆✢✣✤✥❋✦✧✩✰✪✫✬✭✮✯❂✡★✱✲✳✴✵✶✷✸✹✺✻✼❄❅❆❇❈❉❊†☨✞✝☥☦☓☩☯☧☬☸✡♁✙♆。，、＇：∶；?‘’“”〝〞ˆˇ﹕︰﹔﹖﹑•¨….";
    String str6 = "¸;！´？！～—ˉ｜‖＂〃｀@﹫¡¿﹏﹋﹌︴々﹟#﹩\$﹠&﹪%*﹡﹢﹦﹤‐￣¯―﹨ˆ˜﹍﹎+=<＿_-\ˇ~﹉﹊（）〈〉‹›﹛﹜『』〖〗［］《》〔〕{}「」【】︵︷︿︹︽_﹁﹃︻︶︸﹀︺︾ˉ﹂﹄︼☩";
    String str7 = "☩☨☦✞✛✜✝✙✠✚†‡◉○◌◍◎●◐◑◒◓◔◕◖◗❂☢⊗⊙◘◙◍⅟½⅓⅕⅙⅛⅔⅖⅚⅜¾⅗⅝⅞⅘≂≃≄≅≆≇≈≉≊≋≌≍≎≏≐≑≒≓≔≕≖≗≘≙≚≛≜≝≞≟≠≡≢≣≤≥≦≧≨≩⊰⊱⋛⋚∫∬∭∮∯∰∱∲∳%℅‰‱㊣㊎㊍㊌㊋㊏㊐㊊㊚㊛㊤㊥㊦㊧㊨㊒㊞㊑㊒㊓㊔㊕㊖㊗㊘㊜㊝㊟㊠㊡㊢㊩㊪㊫㊬㊭㊮㊯㊰㊙㉿囍♔♕♖♗♘♙♚♛♜♝♞♟ℂℍℕℙℚℝℤℬℰℯℱℊℋℎℐℒℓℳℴ℘ℛℭ℮ℌℑℜℨ♪♫♩♬♭♮♯°øⒶ☮✌☪✡☭✯卐✐✎✏✑✒✍✉✁✂✃✄✆✉☎☏➟➡➢➣➤➥➦➧➨➚➘➙➛➜➝➞➸♐➲➳⏎➴➵➶➷➸➹➺➻➼➽←↑→↓↔↕↖↗↘↙↚↛↜↝↞↟↠↡↢↣↤↥↦↧↨➫➬➩➪➭➮➯➱↩↪↫↬↭↮↯↰↱↲↳↴↵↶↷↸↹↺↻↼↽↾↿⇀⇁⇂⇃⇄⇅⇆⇇⇈⇉⇊⇋⇌⇍⇎⇏⇐⇑⇒⇓⇔⇕⇖⇗⇘⇙⇚⇛⇜⇝⇞⇟⇠⇡⇢⇣⇤⇥⇦⇧⇨⇩⇪➀➁➂➃➄➅➆➇➈➉➊➋➌➍➎➏➐➑➒➓㊀㊁㊂㊃㊄㊅㊆㊇㊈㊉ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩ⒜⒝⒞⒟⒠⒡⒢⒣⒤⒥⒦⒧⒨⒩⒪⒫⒬⒭⒮⒯⒰⒱⒲⒳⒴⒵ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫⅬⅭⅮⅯⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹⅺⅻⅼⅽⅾⅿ┌┍┎┏┐┑┒┓└┕┖┗┘┙┚┛├┝┞┟┠┡┢┣┤┥┦┧┨┩┪┫┬┭┮┯┰┱┲┳┴┵┶┷┸┹┺┻┼┽┾┿╀╁╂╃╄╅╆╇╈╉╊╋╌╍╎╏═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬◤◥◄►▶◀◣◢▲▼◥▸◂▴▾△▽▷◁⊿▻◅▵▿▹◃❏❐❑❒▀▁▂▃▄▅▆▇▉▊▋█▌▍▎▏▐░▒▓▔▕■□▢▣▤▥▦▧▨▩▪▫▬▭▮▯㋀㋁㋂㋃㋄㋅㋆㋇㋈㋉㋊㋋㏠㏡㏢㏣㏤㏥㏦㏧㏨㏩㏪㏫㏬㏭㏮㏯㏰㏱㏲㏳㏴㏵㏶㏷㏸㏹㏺㏻㏼㏽㏾㍙㍚㍛㍜㍝㍞㍟㍠㍡㍢㍣㍤㍥㍦㍧㍨㍩㍪㍫㍬㍭㍮㍯㍰㍘☰☲☱☴☵☶☳☷☯";
    String str8 = "♠♣♧♡♥❤❥❣♂♀✲☀☼☾☽◐◑☺☻☎☏✿❀№↑↓←→√×÷★℃℉°◆◇⊙■□△▽¿½☯✡㍿卍卐♂♀✚〓㎡♪♫♩♬㊚㊛囍㊒㊖Φ♀♂‖\$@*&#※卍卐Ψ♫♬♭♩♪♯♮⌒¶∮‖€￡¥\$";
    String str9 = "①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳⓪⓿❶❷❸❹❺❻❼❽❾❿⓫⓬⓭⓮⓯⓰⓱⓲⓳⓴⓵⓶⓷⓸⓹⓺⓻⓼⓽⓾㊀㊁㊂㊃㊄㊅㊆㊇㊈㊉㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩⑴⑵⑶⑷⑸⑹⑺⑻⑼⑽⑾⑿⒀⒁⒂⒃⒄⒅⒆⒇⒈⒉⒊⒋⒌⒍⒎⒏⒐⒑⒒⒓⒔⒕⒖⒗⒘⒙⒚⒛ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩ⒜⒝⒞⒟⒠⒡⒢⒣⒤⒥⒦⒧⒨⒩⒪⒫⒬⒭⒮⒯⒰⒱⒲⒳⒴⒵";
    String str10 = "﹢﹣×÷±+-*/^=≌∽≦≧≒﹤﹥≈≡≠≤≥≮≯∷∶∝∞∧∨∑∏∪∩∈∵∴⊥∥∠⌒⊙√∛∜∟⊿㏒㏑%‰⅟½⅓⅕⅙⅐⅛⅑⅒⅔¾⅖⅗⅘⅚⅜⅝⅞≂≃≄≅≆≇≉≊≋≍≎≏≐≑≓≔≕≖≗≘≙≚≛≜≝≞≟≢≣≨≩⊰⊱⋛⋚∫∮∬∭∯∰∱∲∳℅øπ∀∁∂∃∄∅∆∇∉∊∋∌∍∎∐−∓∔∕∖∗∘∙∡∢∣∤∦∸∹∺∻∼∾∿≀≁≪≫≬≭≰≱≲≳≴≵≶≷≸≹≺≻≼≽≾≿⊀⊁⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋⊌⊍⊎⊏⊐⊑⊒⊓⊔⊕⊖⊗⊘⊚⊛⊜⊝⊞⊟⊠⊡⊢⊣⊤⊦⊧⊨⊩⊪⊫⊬⊭⊮⊯⊲⊳⊴⊵⊶⊷⊸⊹⊺⊻⊼⊽⊾⋀⋁⋂⋃⋄⋅⋆⋇⋈⋉⋊⋋⋌⋍⋎⋏⋐⋑⋒⋓⋔⋕⋖⋗⋘⋙⋜⋝⋞⋟⋠⋡⋢⋣⋤⋥⋦⋧⋨⋩⋪⋫⋬⋭⋮⋯⋰⋱⋲⋳⋴⋵⋶⋷⋸⋹⋺⋻⋼⋽⋾⋿ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫⅬⅭⅮⅯↁↂↃↅↆↇↈ↉↊↋■□▢▣▤▥▦▧▨▩▪▫▬▭▮▯▰▱▲△▴▵▶▷▸▹►▻▼▽▾▿◀◁◂◃◄◅◆◇◈◉◊○◌◍◎●◐◑◒◓◔◕◖◗◘◙◚◛◜◝◞◟◠◡◢◣◤◥◦◧◨◩◪◫◬◭◮◯◰◱◲◳◴◵◶◷◸◹◺◿◻◼◽◾⏢⏥⌓⌔⌖";
    String str11 = "⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ⁺ ⁻ ⁼ ⁽ ⁾ ⁿ ₀ ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉ ₊ ₋ ₌ ₍ ₎ ₐ ₑ ₒ ₓ ₔ ₕ ₖ ₗ ₘ ₙ ₚ ₛ ₜ";
    String str12 = "♥❣ღ♠♡♤❤❥";

    String str13 = "。，、＇：∶；?‘’“”〝〞ˆˇ﹕︰﹔﹖﹑•¨….¸;！´？！～—ˉ｜‖＂〃｀@﹫¡¿﹏﹋﹌︴々﹟#﹩\$﹠&﹪%*﹡﹢﹦﹤‐￣¯―﹨ˆ˜﹍﹎+=<＿-\ˇ~﹉﹊（）〈〉‹›﹛﹜『』〖〗［］《》〔〕{}「」【】︵︷︿︹︽﹁﹃︻︶︸﹀︺︾ˉ﹂﹄︼❝❞‐‑‒–―‖‗‘’‚‛“”„‟†‡•‣․‥…‧‪‫‬‭‮ ‰‱′″‴‵‶‷‸※‼‽‾‿⁀⁁⁂⁃⁄⁇⁈⁉⁊⁋⁌⁍⁎⁏⁐⁑⁒⁓⁔⁕⁖⁗⁘⁙⁚⁛⁜⁝⁞ ⁠⁡⁢⁣⁤";
    String str14 = "€£Ұ₴\$₰¢₤¥₳₲₪₵元₣₱฿¤₡₮₭₩ރ円₢₥₫₦zł﷼₠₧₯₨Kčर₹ƒ₸￠";
    String str15 = "↑↓←→↖↗↘↙↔↕➻➼➽➸➳➺➻➴➵➶➷➹▶►▷◁◀◄«»➩➪➫➬➭➮➯➱⏎➲➾➔➘➙➚➛➜➝➞➟➠➡➢➣➤➥➦➧➨↚↛↜↝↞↟↠↠↡↢↣↤↤↥↦↧↨⇄⇅⇆⇇⇈⇉⇊⇋⇌⇍⇎⇏⇐⇑⇒⇓⇔⇖⇗⇘⇙⇜↩↪↫↬↭↮↯↰↱↲↳↴↵↶↷↸↹☇☈↼↽↾↿⇀⇁⇂⇃⇞⇟⇠⇡⇢⇣⇤⇥⇦⇧⇨⇩⇪↺↻⇚⇛♐";
    String str16 = "✐✎✏✑✒✍✉✁✂✃✄✆✉☎☏☑✓✔√☐☒✗✘ㄨ✕✖✖☢☠☣✈★☆✡囍㍿☯☰☲☱☴☵☶☳☷☜☞☝✍☚☛☟✌♤♧♡♢♠♣♥♦☀☁☂❄☃♨웃유❖☽☾☪✿♂♀✪✯☭➳卍卐√×■◆●○◐◑✙☺☻❀⚘♔♕♖♗♘♙♚♛♜♝♞♟♧♡♂♀♠♣♥❤☜☞☎☏⊙◎☺☻☼▧▨♨◐◑↔↕▪▒◊◦▣▤▥▦▩◘◈◇♬♪♩♭♪の★☆→あぃ￡Ю〓§♤♥▶¤✲❈✿✲❈➹☀☂☁【】┱┲❣✚✪✣✤✥✦❉❥❦❧❃❂❁❀✄☪☣☢☠☭ღ▶▷◀◁☀☁☂☃☄★☆☇☈⊙☊☋☌☍ⓛⓞⓥⓔ╬『』∴☀♫♬♩♭♪☆∷﹌の★◎▶☺☻►◄▧▨♨◐◑↔↕↘▀▄█▌◦☼♪の☆→♧ぃ￡❤▒▬♦◊◦♠♣▣۰•❤•۰►◄▧▨♨◐◑↔↕▪▫☼♦⊙●○①⊕◎Θ⊙¤㊣★☆♀◆◇◣◢◥▲▼△▽⊿◤◥✐✌✍✡✓✔✕✖♂♀♥♡☜☞☎☏⊙◎☺☻►◄▧▨♨◐◑↔↕♥♡▪▫☼♦▀▄█▌▐░▒▬♦◊◘◙◦☼♠♣▣▤▥▦▩◘◙◈♫♬♪♩♭♪✄☪☣☢☠♯♩♪♫♬♭♮☎☏☪♈ºº₪¤큐«»™♂✿♥　◕‿-｡　｡◕‿◕｡";
    String str17 = "ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζνξοπρσηθικλμτυφχψω";
    String str18 = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя";
    String str19 = "āáǎàōóǒòēéěèīíǐìūúǔùǖǘǚǜüêɑńňɡㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦㄧㄨㄩ";
    String str20 = "零壹贰叁肆伍陆柒捌玖拾佰仟万亿吉太拍艾分厘毫微卍卐卄巜弍弎弐朤氺曱甴囍兀々〆のぁ〡〢〣〤〥〦〧〨〩㊎㊍㊌㊋㊏㊚㊛㊐㊊㊣㊤㊥㊦㊧㊨㊒㊫㊑㊓㊔㊕㊖㊗㊘㊜㊝㊞㊟㊠㊡㊢㊩㊪㊬㊭㊮㊯㊰㊀㊁㊂㊃㊄㊅㊆㊇㊈㊉";
    String str21 = "ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺ・ーヽヾヿ゠ㇰㇱㇲㇳㇴㇵㇶㇷㇸㇹㇺㇻㇼㇽㇾㇿ";
    String str22 = "─ ━│┃╌╍╎╏┄ ┅┆┇┈ ┉┊┋┌┍┎┏┐┑┒┓└ ┕┖┗ ┘┙┚┛├┝┞┟┠┡┢┣ ┤┥┦┧┨┩┪┫┬ ┭ ┮ ┯ ┰ ┱ ┲ ┳ ┴ ┵ ┶ ┷ ┸ ┹ ┺ ┻┼ ┽ ┾ ┿ ╀ ╁ ╂ ╃ ╄ ╅ ╆ ╇ ╈ ╉ ╊ ╋ ╪ ╫ ╬═║╒╓╔ ╕╖╗╘╙╚ ╛╜╝╞╟╠ ╡╢╣╤ ╥ ╦ ╧ ╨ ╩ ╳╔ ╗╝╚ ╬ ═ ╓ ╩ ┠ ┨┯ ┷┏ ┓┗ ┛┳ ⊥ ﹃ ﹄┌ ╮ ╭ ╯╰";
    String str23 = "🌹🍀🍎💰📱🌙🍁🍂🍃🌷💎🔪🔫🏀⚽⚡👄👍🔥";
    String str24 = "♚　♛　♝　♞　♜　♟　♔　♕　♗　♘　♖　♟";



    RegExp exp = RegExp(r"(\w+)");
    String str1 = "device.";
    bool flog = checkContainsSymbol(str1);
    print(flog);
    print("text = " + exp.hasMatch(str1).toString());
    Iterable matches = exp.allMatches(str1);
    for (var match in matches) {
      //todo 读取文字时可能会抛异常会崩溃   例如str14
      print(str1.substring(match.start, match.end));
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
  ///检测字符串中是否包含符号
  ///
  bool checkContainsSymbol(String str){
    RegExp exp = RegExp(r"(\w+)");
    bool flog =false;
    if(str.contains(" "))return false;
    for(int i =0;i<str.length;i++)
    {

      flog = exp.hasMatch(str.substring(i,i+1));
      if(!flog){
        return false;

      }
    }
    return true;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  List<TextLine>? textLineAll = [];
  PdfDocument? document;

  ///点击加号获取pdf第二页的数据
  void _incrementCounter() async{
    document = PdfDocument(
        inputBytes: await _readDocumentData('gis_succinctly.pdf'));

    //Extracts the text line collection from the document
    textLineAll = PdfTextExtractor(document!).extractTextLines(startPageIndex: 2);
    document!.dispose();
  }
  PdfViewerController pdfViewerController = PdfViewerController();
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    late PdfTextSearchResult _searchResult;



    @override
    void initState() {
      _searchResult = PdfTextSearchResult();
      pdfViewerController = PdfViewerController();

      super.initState();
    }

    OverlayEntry _overlayEntry;
    void _showContextMenu(BuildContext context,PdfTextSelectionChangedDetails details) {
      final OverlayState? _overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: details.globalSelectedRegion!.center.dy - 55,
          left: details.globalSelectedRegion!.bottomLeft.dx,
          child:
          RaisedButton(child: Text('Copy',style: TextStyle(fontSize: 17)),onPressed: (){
            Clipboard.setData(ClipboardData(text: details.selectedText));
            // _pdfViewerController.clearSelection();
          },color: Colors.red,elevation: 10,),
        ),
      );
      // _overlayState.insert(_overlayEntry);
    }

    late OverlayEntry overlayEntry ;
    bool flog;

    return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion Flutter PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.red,
            ),
            onPressed: () async {
              _searchResult = await pdfViewerController.searchText('exactly',
                  searchOption: TextSearchOption.caseSensitive);
              print(
                  'Total instance count: ${_searchResult.totalInstanceCount}');
              // _searchResult.clear();
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Stack(
          children: [
            Container(
                child: SfPdfViewer.asset("assets/pdf/gis_succinctly.pdf",
                  onTextSelectionChanged:
                      (PdfTextSelectionChangedDetails details) {

                    if (details.selectedText == null ) {
                      // _overlayEntry.remove();
                      // _overlayEntry = null;
                    } else if (details.selectedText != null ) {
                      _showContextMenu(context, details);
                    }
                  },
                  searchTextHighlightColor: Color(0x004985FD) ,
                  //当点击的文字改变时
                  onSelectionText:(PdfSelectionTextDetails details){

                  //循环行数据
                    for (int textLineIndex = 0; textLineIndex < textLineAll!.length; textLineIndex++) {
                      final TextLine? line = textLineAll![textLineIndex];//每行的数据
                      final List<TextWord> textWordCollection = line!.wordCollection;//从行数据取出字的数据位置等信息
                      for (int wordIndex = 0; wordIndex < textWordCollection.length; wordIndex++) {//循环字的数据
                        final TextWord textWord = textWordCollection[wordIndex];

                        final Rect wordBounds = textWord.bounds;//获取字的位置信息
                        //判断点击位置是否为空，和第二页字的信息中是否包含点击的字的位置信息
                        if (details.offset != null && wordBounds.contains(details.offset! * details.heightPercentage!)) {
                          print("点击的文字是： " + textWord.text);//取到点击的文字
                          print("点击的line = " + line.text);//取到点击的行的文字

                          //点击一个词后，获取整句话 然后高亮信息
                          List<MatchedItem> textLines = getSentence(textLineAll!,textLineIndex,textWordCollection,wordIndex);
                          List<MatchedItem>? items = [];
                          MatchedItem matchedItems = new MatchedItem(textWord.text, textWord.bounds, 2);
                          items.add(matchedItems);
                          //获取字的高亮信息MatchedItem
                          List<MatchedItem>? item = onBeforeFindWord(wordIndex, textWordCollection);
                          if(item!.isNotEmpty){
                            //单个词改变刷新高亮信息
                            pdfViewerController.setTextInfomation(item);
                          }
                          //句子改变 刷新高亮信息
                          pdfViewerController.setTextInfomationHighLight(textLines);
                          wordInfoListBefore.clear();

                          var nowTime1 = DateTime.now();//获取当前时间
                          print("AAAA---paint font" +nowTime1.toString());
                        }
                      }
                    }
                    setState(() {
                      var nowTime1 = DateTime.now();//获取当前时间
                      print("AAAA---paint callback " +nowTime1.toString());
                      flog = true;});
                  },
                  controller: pdfViewerController,

                  // controller: _pdfViewerController,
                )),
                  ElevatedButton(
                    child: Text("点击高亮显示文字"),
                    onPressed: () async{
                      getTextPostion();
                      // _searchResult = await pdfViewerController.searchText('exactly',
                      //     searchOption: TextSearchOption.caseSensitive,);
                    },
                  ),
          ],
        ),



      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), );
  }

  ///进入应用后自动读取文字，传入文字给插件，根据文字找到文字的位置
  void getTextPostion() async{
    PdfDocument document = PdfDocument(inputBytes: await _readDocumentData('gis_succinctly.pdf'));
    final List<TextLine> textLine = PdfTextExtractor(document).extractTextLines(startPageIndex: 2);//第二页的pdf
    TextLine line = textLine[3];//第三行的行数据
    Rect bounds = line.bounds;
    List<TextWord> textWordCollection = line.wordCollection;
    document.dispose();

    onAfterFindWord(line, textWordCollection);
  }

  ///检测字符串中是否包含符号
  ///
  bool checkContainsSymbol(String str){
    RegExp exp = RegExp(r"(\w+)");
    bool flog =false;
    if(str.contains(" "))return false;
    for(int i =0;i<str.length;i++)
    {
      flog = exp.hasMatch(str.substring(i,i+1));

      if(!flog){
        return false;
      }
    }
    return true;
  }

  ///检测字符串中是否包含符号
  ///
  bool checkContainsAfterSymbol(String str){
    RegExp exp = RegExp(r"(\w+)");
    bool flog =false;
    if(str.contains(" "))return false;
    for(int i =0;i<str.length;i++)
    {
      flog = exp.hasMatch(str.substring(i,i+1));

      if(!flog){
        if(str.length > 2){
          return true;
        }
        return false;
      }
    }
    return true;
  }

  ///向前查找单词，是否为一整个单词
  /// wordIndex点击的单词坐标
  /// List<TextWord> textWordCollection  每行单词的合集
  List<MatchedItem>? onBeforeFindWord(int wordIndex,List<TextWord> textWordCollection){
    List<MatchedItem>? item = [];
    ///for(int k = i;k < textWordCollection.length ;k++){
    int index = wordIndex - 1;///当前需要读取的单词
    String text = "";
    ///向前取字符数据
    for(int k = index; k >= 0; k--){
      if(checkContainsSymbol(textWordCollection[k].text)) {
        text += textWordCollection[k].text;
        MatchedItem matchedItems = new MatchedItem(text, textWordCollection[k].bounds, 2);
        item.add(matchedItems);
        index=k;
      }
      else{
        break;
      }
    }

    ///向后取字符数据
    for(int k = wordIndex;k < textWordCollection.length ;k++){
      if(checkContainsAfterSymbol(textWordCollection[k].text)) {
        if(checkContainsSymbol(textWordCollection[k].text)){
          text += textWordCollection[k].text;
          MatchedItem matchedItems = new MatchedItem(text, textWordCollection[k].bounds, 2);
          item.add(matchedItems);
          wordIndex=k;

        }else {
          if(checkContainsAfterSymbol(textWordCollection[k].text)){
            text += textWordCollection[k].text;
            MatchedItem matchedItems = new MatchedItem(text, textWordCollection[k].bounds, 2);
            item.add(matchedItems);
            wordIndex=k;
          }
          break;
        }
      }
      else{
        break;
      }
    }

    ///计算出空格等是否显示高亮
    List<double> geekList = [];
    for(int i = 0;i<item.length;i++){
      geekList.add(item[i].bounds.left);
    }
    geekList.sort();

    List<MatchedItem>? items = [];
    MatchedItem matchedItems = new MatchedItem(text, new Rect.fromLTRB(geekList.first, item[item.length-1].bounds.top, item[item.length-1].bounds.right, item[item.length-1].bounds.bottom), 2);
    items.add(matchedItems);


    return items;
  }


  //自动读取行数据，行显示次高亮，词延时1秒分别显示高亮
  void onAfterFindWord(TextLine line,List<TextWord> textWordCollection) async{
    print("line = " + line.text);
    List<MatchedItem>? items = [];

    //循环词的数据
    for(int i =0;i<textWordCollection.length;i++){
      if(i == 0){
        List<MatchedItem>? itemLinex = [];
        MatchedItem matchedItem = new MatchedItem(line.text, line.bounds, 2);//第二页的行数据
        itemLinex.add(matchedItem);
        MatchedItem matchedItems = new MatchedItem("text", textWordCollection[i].bounds, 2);//第二页的词数据
        items.add(matchedItems);
        pdfViewerController.setTextInfomationHighLight(itemLinex);//显示行高亮的方法
        pdfViewerController.setTextInfomation(items);//显示词高亮的方法
        await Future.delayed(Duration(milliseconds: 1000), () {//延时一秒显示词
          // pdfViewerController.setTextInfomation('exactly', textWordCollection[i].bounds,2);
        });
      }else{
        //同样  读取词可能是一个字母，所以要向前、向后查找是否能组成一个词
        String text = "";

        List<MatchedItem>? itemLinex = [];
        MatchedItem matchedItem = new MatchedItem(line.text, line.bounds, 2);
        itemLinex.add(matchedItem);

        List<MatchedItem>? item = [];
        ///向后查找单词是否为一整个单词
        for(int k = i;k < textWordCollection.length ;k++){
          if(checkContainsAfterSymbol(textWordCollection[k].text)) {
            if(checkContainsSymbol(textWordCollection[k].text)){
              text += textWordCollection[k].text;
              MatchedItem matchedItems = new MatchedItem(text, textWordCollection[k].bounds, 2);
              item.add(matchedItems);
              i=k;

            }else {
              if(checkContainsAfterSymbol(textWordCollection[k].text)){
                text += textWordCollection[k].text;
                MatchedItem matchedItems = new MatchedItem(text, textWordCollection[k].bounds, 2);
                item.add(matchedItems);
                i=k;
              }
              break;
            }
          }
          else{
            break;
          }
        }
        List<MatchedItem>? items = [];
        if(item.length > 0){
          ///计算出空格等是否显示高亮
          List<double> geekList = [];
          for(int i = 0;i<item.length;i++){
            geekList.add(item[i].bounds.left);
          }
          geekList.sort();

          MatchedItem matchedItems = new MatchedItem(text, new Rect.fromLTRB(geekList.first, item[item.length-1].bounds.top, item[item.length-1].bounds.right, item[item.length-1].bounds.bottom), 2);
          items.add(matchedItems);
          // pdfViewerController.setTextInfomationHighLight(itemLinex);
          if(item.isNotEmpty){
            pdfViewerController.setTextInfomation(items);
            await Future.delayed(Duration(milliseconds: 1000), () {
              // pdfViewerController.setTextInfomation('exactly', textWordCollection[i].bounds,2);
            });
          }
        }else{
          // pdfViewerController.setTextInfomationHighLight(itemLinex);
          if(item.isNotEmpty){
            pdfViewerController.setTextInfomation(item);
            await Future.delayed(Duration(milliseconds: 1000), () {
              // pdfViewerController.setTextInfomation('exactly', textWordCollection[i].bounds,2);
            });
          }
        }
      }
    }

  }

  ///点击一个词后，获取整句话 然后高亮
  List<MatchedItem> getSentence( List<TextLine> textLineAll,int textLineIndex,List<TextWord> textWordCollection,int wordIndex){
    List<MatchedItem> matchedItemList = [];
    List<TextWord> wordInfoList = [];//增加到最后的数据中，然后显示行的高亮

    int wordIndexSame;//同行的时候取点击后的文字
    List<TextWord> textWordCollectionSame;//同行单词的数组
    //同一行的情况，取当前位置的文字信息和行信息
    wordIndexSame = wordIndex;
    textWordCollectionSame = textLineAll[textLineIndex].wordCollection;

    bool firstIsAdd = false;//向前查找，检查当前行是否有标点，如果没有，则j==0的时候增加第一个坐标点
    for( int j = wordIndexSame; j >= 0; j--){
      if(j == wordIndexSame){//如果当前点击的是带标点符号的字则执行向前查找的逻辑
        if(!checkContainsSentenceSymbol(textWordCollectionSame[j].text)){
          wordInfoList.insert(0,textWordCollectionSame[j]);
          if(j==0){
            if(j == 0){
              //向后查找，检查当前行是否有标点   如果当前行没有标点则添加最后一个文字信息
              if(!firstIsAdd){
                wordInfoList.insert(0,textWordCollectionSame[0]);
                wordInfoListBefore.add(wordInfoList);
              }
            }
            break;
          }else{
            j--;
          }
        }
      }

        if(!checkContainsSentenceSymbol(textWordCollectionSame[j].text)){
          print("text = "+textWordCollectionSame[j].text);


          if(j==textWordCollectionSame.length-1){
            wordInfoList.insert(0,textWordCollectionSame[j]);
          }else{
            wordInfoList.insert(0,textWordCollectionSame[j+1]);
          }

          firstIsAdd = true;
          wordInfoListBefore.add(wordInfoList);
          //如果点击的是有标点符号的字
          break;
        }

      if(j == 0){
        //向后查找，检查当前行是否有标点   如果当前行没有标点则添加最后一个文字信息
        if(!firstIsAdd){
            wordInfoList.insert(0,textWordCollectionSame[0]);
            wordInfoListBefore.add(wordInfoList);
        }
      }
    }
    List<List<TextWord>> beforeList = [];
    //wordInfoListBefore
    if(!firstIsAdd){
      beforeList = BeforeFindLineInfo(textLineAll, textLineIndex,textWordCollection, wordIndex);
    }


    print("开始向后查找");
    bool lastIsAdd = false;//向后查找，检查当前行是否有标点，则j==最后一个下标的坐标点
    for( int j = wordIndexSame; j < textWordCollectionSame.length; j++){
      if(!checkContainsSymbol(textWordCollectionSame[j].text)){
        if(!checkContainsSentenceSymbol(textWordCollectionSame[j].text)){
          print("向后查找 text1 = "+textWordCollectionSame[j].text);
          wordInfoList.add(textWordCollectionSame[j]);
          lastIsAdd = true;
          //如果点击的是有标点符号的字

          break;
        }
      }
      if(j == textWordCollectionSame.length-1){
        //向后查找，检查当前行是否有标点   如果当前行没有标点则添加最后一个文字信息
        if(!lastIsAdd){
          wordInfoList.add(textWordCollectionSame[textWordCollectionSame.length-1]);
        }
      }
    }
    List<List<TextWord>> afterList = [];
    if(!lastIsAdd){
      if(textLineIndex != textLineAll.length-1) {
        afterList = AfterFindLineInfo(textLineAll, textLineIndex, textWordCollection, wordIndex);
      }
    }


      if(wordInfoList.length > 0){
        if(beforeList.length<=0 && afterList.length<=0){
          MatchedItem matchedItems = new MatchedItem(wordInfoList[0].text, new Rect.fromLTRB(wordInfoList[0].bounds.left,
              wordInfoList[0].bounds.top,
              wordInfoList[wordInfoList.length-1].bounds.right,
              wordInfoList[wordInfoList.length-1].bounds.bottom), 2);
          matchedItemList.add(matchedItems);
        }


        if(beforeList.length>0){
          for(int i = 0;i< beforeList.length;i++){
            MatchedItem matchedItems = new MatchedItem(beforeList[i][0].text, new Rect.fromLTRB(beforeList[i][0].bounds.left,
                beforeList[i][0].bounds.top,
                beforeList[i][beforeList[i].length-1].bounds.right,
                beforeList[i][beforeList[i].length-1].bounds.bottom), 2);
            matchedItemList.add(matchedItems);
          }
        }

        if(afterList.length>0){
          for(int i = 0;i< afterList.length;i++){
            MatchedItem matchedItems = new MatchedItem(afterList[i][0].text, new Rect.fromLTRB(afterList[i][0].bounds.left,
                afterList[i][0].bounds.top,
                afterList[i][afterList[i].length-1].bounds.right,
                afterList[i][afterList[i].length-1].bounds.bottom), 2);
            matchedItemList.add(matchedItems);
          }
        }
        //如果向前和向后坐标有重复的则删除掉
        if(matchedItemList.length >= 2){
          for(int i = 0;i< matchedItemList.length;i++){
            for(int j =0;j<matchedItemList.length;j++){
              if(i != j){
                if(matchedItemList[i].bounds == matchedItemList[j].bounds){
                  matchedItemList.removeAt(j);
                }
              }
            }
          }
        }
      }else{
        wordInfoList.add(textWordCollectionSame[textWordCollectionSame.length-1]);
        MatchedItem matchedItems = new MatchedItem(wordInfoList[0].text, new Rect.fromLTRB(textWordCollectionSame[wordIndex].bounds.left, wordInfoList[0].bounds.top, wordInfoList[0].bounds.right, wordInfoList[0].bounds.bottom), 2);
        matchedItemList.add(matchedItems);
      }

   return matchedItemList;

  }

  List<List<TextWord>>   AfterFindLineInfo(List<TextLine> textLineAll,int textLineIndex,List<TextWord> textWordCollection,int wordIndex){

    int wordIndexSame;//同行的时候取点击后的文字
    List<TextWord> textWordCollectionSame;//同行单词的数组
    //同一行的情况，取当前位置的文字信息和行信息
    wordIndexSame = wordIndex;
    int lineIndex = textLineIndex;
    textWordCollectionSame = textLineAll[lineIndex].wordCollection;

    bool lastIsAdd = false;//向后查找，检查当前行是否有标点，则j==最后一个下标的坐标点
    while(!lastIsAdd){
      List<TextWord> wordInfoList = [];//增加到最后的数据中，然后显示行的高亮
      //向上一行查找文字信息
      lineIndex++;
      wordIndexSame = 0;
      textWordCollectionSame = textLineAll[lineIndex].wordCollection;


      for( int j = wordIndexSame; j < textWordCollectionSame.length; j++){
        if(!checkContainsSymbol(textWordCollectionSame[j].text)){
          if(!checkContainsSentenceSymbol(textWordCollectionSame[j].text)){
            print("text1 = "+textWordCollectionSame[j].text);
            wordInfoList.add(textWordCollectionSame[0]);
            wordInfoList.add(textWordCollectionSame[j]);
            wordInfoListBefore.add(wordInfoList);
            lastIsAdd = true;
            //如果点击的是有标点符号的字
            //wordInfoList.add(textWordCollectionSame[textWordCollectionSame.length-1]);
            break;
          }
        }
        if(j == textWordCollectionSame.length-1){
          //向后查找，检查当前行是否有标点   如果当前行没有标点则添加最后一个文字信息
          if(!lastIsAdd){
            wordInfoList.add(textWordCollectionSame[0]);
            wordInfoList.add(textWordCollectionSame[textWordCollectionSame.length-1]);
            wordInfoListBefore.add(wordInfoList);
          }
        }
      }
    }


    return wordInfoListBefore;
  }
  List<List<TextWord>> wordInfoListBefore = [];

  ///向前查找数据
  List<List<TextWord>>  BeforeFindLineInfo(List<TextLine> textLineAll,int textLineIndex,List<TextWord> textWordCollection,int wordIndex){

    List<MatchedItem> matchedItemList = [];

    int wordIndexSame;//同行的时候取点击后的文字
    List<TextWord> textWordCollectionSame;//同行单词的数组
    //同一行的情况，取当前位置的文字信息和行信息
    wordIndexSame = wordIndex;
    int lineIndex = textLineIndex;
    textWordCollectionSame = textLineAll[lineIndex].wordCollection;
    bool firstIsAdd = false;//向前查找，检查当前行是否有标点，如果没有，则j==0的时候增加第一个坐标点
    while(!firstIsAdd){
      List<TextWord> wordInfoList = [];//增加到最后的数据中，然后显示行的高亮
      //向上一行查找文字信息
      lineIndex--;
      wordIndexSame = textLineAll[lineIndex].wordCollection.length-1;
      textWordCollectionSame = textLineAll[lineIndex].wordCollection;
      if(!firstIsAdd){
        for( int j = wordIndexSame; j >= 0; j--){
          if(!checkContainsSentenceSymbol(textWordCollectionSame[j].text)){
            print("text = "+textWordCollectionSame[j].text);
            if(j==textWordCollectionSame.length-1){
              // wordInfoList.insert(0,textWordCollectionSame[j]);
            }else{
              wordInfoList.insert(0,textWordCollectionSame[j+1]);
              wordInfoList.add(textWordCollectionSame[textWordCollectionSame.length-1]);
              wordInfoListBefore.add(wordInfoList);
            }
            firstIsAdd = true;
            //如果点击的是有标点符号的字
            break;
          }
          if(j == 0){
            //向后查找，检查当前行是否有标点   如果当前行没有标点则添加最后一个文字信息
            if(!firstIsAdd){
              wordInfoList.add(textWordCollectionSame[0]);
              wordInfoList.add(textWordCollectionSame[textWordCollectionSame.length-1]);
              // AfterFindLineInfo(textLineAll,lineIndex,textWordCollection,wordIndexSame);
              wordInfoListBefore.add(wordInfoList);
            }
          }
        }
      }
    }

    return wordInfoListBefore;
  }

  bool checkContainsSentenceSymbol(String str){
    RegExp exp = RegExp(r"(\w+)");
    bool flog =false;
    if(str.contains(" ")) {
      if(str.contains(",")||str.contains(".")||str.contains(":")||str.contains(";")||str.contains("?")
          ||str.contains("+")||str.contains("=")||str.contains("~")||str.contains("!")||str.contains("#")
          ||str.contains("\$")||str.contains("%")||str.contains("&")||str.contains("*")) {
        return false;
      }
      return true;
    }
      for(int i =0;i<str.length;i++)
      {
        flog = exp.hasMatch(str.substring(i,i+1));
        if(str.substring(i,i+1).contains("(")||str.substring(i,i+1).contains(")")){
          return true;
        }
        else if(!flog){
          return false;
        }
      }
      return true;
  }

  void setHighLightText(){

  }
}
