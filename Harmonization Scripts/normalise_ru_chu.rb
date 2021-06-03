# coding: utf-8
srb = File.open('new.conllu')

def translit_ru(t)   
  t.gsub(/ся\z/,'сѧ').gsub(/ё/,'е').gsub(/ja/,'ꙗ').gsub(/ju/,'ю').gsub(/je/,'е').gsub(/ji/,'и').gsub(/jo/,'е').gsub(/lj/,'ль').gsub(/rj/,'рь').gsub(/nj/,'нь').gsub(/Ja/,'Ꙗ').gsub(/Ju/,'Ю').gsub(/Je/,'Е').gsub(/Ji/,'И').gsub(/Jo/,'Е').gsub(/Lj/,'Ль').gsub(/Rj/,'Рь').gsub(/Нь/,'Nj').gsub(/a/,'а').gsub(/b/,'б').gsub(/c/,'ц').gsub(/č/,'ч').gsub(/ć/,'щ').gsub(/d/,'д').gsub(/e/,'е').gsub(/f/,'ф').gsub(/g/,'г').gsub(/h/,'х').gsub(/i/,'и').gsub(/j/,'и').gsub(/k/,'к').gsub(/l/,'л').gsub(/m/,'м').gsub(/n/,'н').gsub(/o/,'о').gsub(/p/,'п').gsub(/r/,'р').gsub(/s/,'с').gsub(/t/,'т').gsub(/u/,'у').gsub(/v/,'в').gsub(/z/,'з').gsub(/š/,'ш').gsub(/ž/,'ж').gsub(/đ/,'жд').gsub(/â/,'а').gsub(/y/,'ы').gsub(/x/,'кс').gsub(/ﬂ/,'фл').gsub(/A/,'А').gsub(/B/,'Б').gsub(/C/,'Ц').gsub(/Č/,'Ч').gsub(/Ć/,'Щ').gsub(/D/,'Д').gsub(/E/,'Е').gsub(/F/,'Ф').gsub(/G/,'Г').gsub(/H/,'Х').gsub(/I/,'И').gsub(/J/,'И').gsub(/K/,'К').gsub(/L/,'Л').gsub(/M/,'М').gsub(/N/,'Н').gsub(/O/,'О').gsub(/P/,'П').gsub(/R/,'Р').gsub(/S/,'С').gsub(/T/,'Т').gsub(/U/,'у').gsub(/V/,'В').gsub(/w/,'у').gsub(/W/,'у').gsub(/X/,'Х').gsub(/Y/,'Ы').gsub(/Z/,'З').gsub(/Ž/,'Ж').gsub(/Š/,'Ш').gsub(/Đ/,'Жд')
  end

srb.each_line do |l|
  if l =~ /#/
    STDOUT.puts l
  elsif l == "\n"
    STDOUT.puts l
  else
    a = l.split()
    form = translit_ru(a[1])
    lemma = translit_ru(a[2])
    pos = a[3]
    morph = a[5]
    head_id = a[6]
    rel = a[7]
    if pos =~ /VERB|AUX/
      if morph =~ /Person=3\|Tense=Pres\|VerbForm=Fin/
        if morph =~ /Number=Sing/
          form2 =  form.gsub(/т\z/,'тъ')
        elsif morph =~ /Number=Plur/
          if form =~ /ят\z/
            form2 = form.gsub(/ят\z/,'ѧтъ')
          elsif form =~ /ут\z/
            form2 = form.gsub(/ут\z/,'ѫтъ')
          else
            form2 = form.gsub(/ют\z/,'ѭтъ')
          end
        else form2 = form
        end
      elsif morph =~ /Inf/
        if form =~ /чи\z/
          form2 = form.gsub(/чи\z/,'щи')
        else form2 = form.gsub(/ь\z/,'и')
        end
      elsif morph =~ /Aspect=Res\|Case=Nom\|Gender=Masc/
        form2 = form + 'ъ'
        STDERR.puts form2,morph
      elsif morph =~ /VerbForm=Ger/
        if morph =~ /Past/
          form2 = form + 'ъ'
        elsif morph =~ /Pres/
          if form =~ /ая\z|яя\z/
            form2 = form.gsub(/ая\z|яя\z/,'ѧи')
          elsif form =~ /уя\z/
            form2 = form.gsub(/я\z, 'ѧ'/)
          else form2 = form
          end
        else form2 = form
        end
      elsif morph =~ /VerbForm=Part/
        if form =~ /ый\z/
          form2 = form.gsub(/ый\z/, 'ꙑ')
        elsif form =~ /ой\z/
          if morph =~ /Case=Gen/
             form2 = form.gsub(/ой\z/, 'ꙑѩ')
          elsif morph =~ /Case=Dat/
             form2 = form.gsub(/ой\z/, 'ѣи')
          elsif morph =~ /Case=Loc/
             form2 = form.gsub(/ой\z/, 'ѣи')
          elsif morph =~ /Case=Ins/
             form2 = form.gsub(/ой\z/, 'оѭ')
          else form2 = form.gsub(/й\z/, 'и')
          end
        elsif form =~ /ые\z/                           
          form2 = form.gsub(/ые\z/, 'ии')
        elsif form =~ /шая/
          form2 = form.gsub(/шая/, 'ъши')
        elsif form =~ /нное\z/
          form2 = form.gsub(/нное\z/, 'но')
        elsif form =~ /ятое\z/
          form2 = form.gsub(/ятое/, 'ѧто')
        elsif form =~ /ющая/
          form2 = form.gsub(/ющая/, 'ѭшти')
        elsif form =~ /ущая/
          form2 = form.gsub(/ущая/, 'ѫшти')
        elsif form =~ /ящая/
          form2 = form.gsub(/ящая/, 'ѧшти')
        elsif form =~ /яющий|ующий|ущий/
          form2 = form.gsub(/яющий|ующий|ущий/, 'ѧ')
        else
          form2 = form
        end
      else
          form2 = form
      end
    elsif pos =~ /PROPN/ and morph =~ /Case=Nom\|Gender=Masc\|Number=Sing/
      if form =~ /ч\z|ш\z|ж\z|ц\z/
        form2 = form + 'ь'
      elsif form =~ /а\z|е\z|и\z|о\z|у\z|ы\z|ь\z|й\z|\.\z/
        form2 = form
      else
        form2 = form + 'ъ'
      end
    elsif pos =~ /NOUN/
      if morph =~ /Case=Nom\|Gender=Masc\|Number=Sing/
        if form =~ /ч\z|ш\z|ж\z|ц\z/
          form2 = form + 'ь'
        elsif form =~ /а\z|е\z|и\z|о\z|у\z|ы\z|ь\z|й\z|я\z|ю\z|у\z|\.\z/
          form2 = form
        else
          form2 = form + 'ъ'
        end
      elsif morph =~ /Case=Gen\|Gender=Fem\|Number=Sing/
        if lemma =~ /Ь\z/
          form2 = form
        elsif form =~ /ки\z|ги\z|хи\z/
          form2 = form.gsub(/и\z/,'ы')
        elsif form =~ /и\z|цы\z/
          form2 = form.gsub(/и\z/,'ѧ')
        else form2 = form
        end
      elsif morph =~ /Case=Acc\|Gender=Fem\|Number=Sing/
        if lemma =~ /Ь\z/
          form2 = form
        elsif form =~ /ю\z/
          form2 = form.gsub(/ю\z/,'ѭ')
        else
          form2 = form.gsub(/у\z/,'ѫ')
        end
      elsif morph =~ /Case=Gen/
        if morph =~ /Number=Plur/
          if form =~ /цов\z/
            form2 = form.gsub(/ов\z/,'ь')
          elsif form =~ /ов\z/
            form2 = form.gsub(/ов\z/,'ъ')
          elsif form =~ /ьев\z/
            form2 = form.gsub(/ьев\z/,'ъ')
          elsif form =~ /ев\z/
            form2 = form.gsub(/ев\z/,'ь')
          elsif form =~ /ей\z/
            form2 = form.gsub(/ей\z/,'ии')
          else form2 = form
          end
        else form2 = form
        end
      elsif morph =~ /Case=Acc\|Gender=Masc\|Number=Sing/
        if form =~ /ч\z|ш\z|ж\z|ц\z/
          form2 = form + 'ь'
        elsif form =~ /а\z|е\z|и\z|о\z|у\z|ы\z|ь\z|й\z|\.\z/
          form2 = form
        else
          form2 = form + 'ъ'
        end
      elsif morph =~ /Case=Gen\|Gender=Neut\|Number=Sing/
        if form =~ /я\z/
           form2 = form.gsub(/я\z/,'ѣ')
        else form2 = form
        end
      elsif morph =~ /Case=Nom\|Gender=Neut\|Number=Plur/
        if form =~ /я\z/
           form2 = form.gsub(/я\z/,'ѣ')
        else form2 = form
        end
      else form2 = form
      end
    elsif pos =~ /ADJ|PRON|DET/
      if form =~ /х\z/
        form2 = form + 'ъ'
      elsif lemma == 'КАЖДЫЙ'
        if morph =~ /Case=Nom\|Gender=Neut\|Number=Sing/
          form2 = 'къждо'
        elsif morph =~ /Case=Nom\|Gender=Masc\|Number=Sing/
          form2 = 'къждо'
        elsif morph =~ /Case=Acc\|Gender=Masc\|Number=Sing/
          form2 = 'къждо'
        elsif morph =~ /Case=Acc\|Gender=Neut\|Number=Sing/
          form2 = 'къждо'
        elsif morph =~ /Case=Gen\|Gender=Neut\|Number=Sing/
          form2 = 'когоджо'
        elsif morph =~ /Case=Gen\|Gender=Masc\|Number=Sing/
          form2 = 'когоджо'
        elsif morph =~ /Case=Nom\|Gender=Neut\|Number=Sing/
          form2 = 'комуждо'
        elsif morph =~ /Case=Dat\|Gender=Masc\|Number=Sing/
          form2 = 'комуждо'
        elsif morph =~ /Case=Gen\|Gender=Fem\|Number=Sing/
          form2 = 'коѧжде'
        else form2 = form
        end
      elsif lemma == 'ЭТОТ'
        if morph =~ /Case=Nom\|Gender=Masc\|Number=Sing/
          form2 = 'сь'
        elsif morph =~ /Case=Nom\|Gender=Neut\|Number=Sing/
          form2 = 'се'
        elsif morph =~ /Case=Acc\|Gender=Neut\|Number=Sing/
          form2 = 'се'
        elsif morph =~ /Case=Acc\|Gender=Masc\|Number=Sing/
          form2 = 'сь'
        elsif morph =~ /Case=Gen\|Gender=Neut\|Number=Sing/
          form2 = 'сего'
        elsif morph =~ /Case=Gen\|Gender=Masc\|Number=Sing/
          form2 = 'сего'
        elsif morph =~ /Case=Dat\|Gender=Neut\|Number=Sing/
          form2 = 'сему'
        elsif morph =~ /Case=Dat\|Gender=Masc\|Number=Sing/
          form2 = 'сему'
        elsif morph =~ /Case=Ins\|Gender=Neut\|Number=Sing/
          form2 = 'симъ'
        elsif morph =~ /Case=Ins\|Gender=Masc\|Number=Sing/
          form2 = 'симъ'
        elsif morph =~ /Case=Loc\|Gender=Neut\|Number=Sing/
          form2 = 'семь'
        elsif morph =~ /Case=Loc\|Gender=Masc\|Number=Sing/
          form2 = 'семь'
        elsif morph =~ /Case=Nom\|Gender=Fem\|Number=Sing/
          form2 = 'си'
        elsif morph =~ /Case=Gen\|Gender=Fem\|Number=Sing/
          form2 = 'сеи'
        elsif morph =~ /Case=Dat\|Gender=Fem\|Number=Sing/
          form2 = 'сеи'
        elsif morph =~ /Case=Ins\|Gender=Fem\|Number=Sing/
          form2 = 'сеѭ҄'
        elsif morph =~ /Case=Loc\|Gender=Fem\|Number=Sing/
          form2 = 'сеи'
        elsif morph =~ /Case=Acc\|Gender=Fem\|Number=Sing/
          form2 = 'сиѭ'
        elsif morph =~ /Case=Nom\|Number=Plur/
          form2 = 'си'
        elsif morph =~ /Case=Gen\|Number=Plur/
          form2 = 'сихъ'
        elsif morph =~ /Case=Loc\|Number=Plur/
          form2 = 'сихъ'
        elsif morph =~ /Case=Dat\|Number=Plur/
          form2 = 'симъ'
        elsif morph =~ /Case=Ins\|Number=Plur/
          form2 = 'сими'
        elsif morph =~ /Case=Acc\|Number=Plur/
          form2 = 'си'
        else form2 = form
        end
      elsif lemma == 'ОН'
        if morph =~ /Case=Acc\|Gender=Fem\|Number=Sing/
          if form =~ /\Aн/
            form2 = 'нѭ'
          else form2 = 'ѭ'
          end
        elsif morph =~ /Case=Gen\|Gender=Fem\|Number=Sing/
          if form =~ /\Aн/
            form2 = 'неѩ'
          else form2 = 'еѩ'
          end
        elsif morph =~ /Case=Ins\|Gender=Fem\|Number=Sing/
          if form =~ /\Aн/
            form2 = 'неѭ'
          else form2 = 'еѭ'
          end
        elsif morph =~ /Case=Dat\|Gender=Fem\|Number=Sing/
          if form =~ /\Aн/
            form2 = 'неи'
          else form2 = 'еи'
          end
        elsif morph =~ /Case=Loc\|Gender=Fem\|Number=Sing/
          if form =~ /\Aн/
            form2 = 'неи'
          else form2 = 'еи'
          end
        elsif morph =~ /Case=Nom\|Gender=Masc\|Number=Sing/
          form2 = 'тъ'
        else form2 = form
        end
      elsif lemma == 'Я'
        if morph =~ /Case=Nom/
          form2 = 'азъ'
        elsif morph =~ /Case=Gen/
          form2 = 'мене'
        elsif morph =~ /Case=Dat/
          form2 = 'мьнѣ'
        elsif morph =~ /Case=Ins/
          form2 = 'мъноѭ'
        elsif morph =~ /Case=Acc/
          form2 = 'мѧ'
        else form2 = form
        end
      elsif lemma == 'МЫ'
        if morph =~ /Case=Dat|Case=Loc/
          form2 = 'намъ'
        elsif morph =~ /Case=Ins/
          form2 = 'нами'
        elsif morph =~ /Case=Acc|Case=Gen/
          form2 = 'насъ'
        else form2 = form
        end
      elsif lemma == 'ТЫ'
        if morph =~ /Case=Ins/
          form2 = 'тобоѭ'
        elsif morph =~ /Case=Gen/
          form2 = 'тебе'
        elsif morph =~ /Case=Acc/
          form2 = 'тѧ'
        elsif morph =~ /Case=Dat|Case=Loc/
          form2 = 'тебѣ'
        else form2 = form
        end
      elsif lemma == 'ВЫ'
        if morph =~ /Case=Dat|Case=Loc/
          form2 = 'вамъ'
        elsif morph =~ /Case=Ins/
          form2 = 'вами'
        elsif morph =~ /Case=Acc|Case=Gen/
          form2 = 'васъ'
        else form2 = form
        end
      elsif lemma == 'ЧТО'
        if rel =~ /SCONJ/
          form2 = 'ѣко'
        elsif morph =~ /Case=Nom/
          form2 = 'чьто'
        elsif morph =~ /Case=Gen/
          form2 = 'чесо'
        elsif morph =~ /Case=Dat/
          form2 = 'чьсому'
        elsif morph =~ /Case=Ins/
          form2 = 'чемъ'
        else form2 = form
        end
      elsif lemma == 'КОТОРЫЙ'
        if morph =~ /Case=Nom\|Gender=Masc\|Number=Sing/
          form2 = 'иже'
        elsif morph =~ /Case=Nom\|Gender=Neut\|Number=Sing/
          form2 = 'егоже'
        elsif morph =~ /Case=Nom\|Gender=Masc\|Number=Sing/
          form2 = 'егоже'
        elsif morph =~ /Case=Nom\|Gender=Neut\|Number=Sing/
          form2 = 'еже'
        elsif morph =~ /Case=Gen\|Number=Plur/
          form2 = 'ихъже'
        elsif morph =~ /Case=Ins\|Gender=Masc\|Number=Sing/
          form2 = 'имъже'
        elsif morph =~ /Case=Dat\|Number=Plur/
          form2 = 'имъже'
        elsif morph =~ /Case=Nom\|Gender=Fem\|Number=Sing/
          form2 = 'ꙗже'
        elsif morph =~ /Case=Dat\|Gender=Masc\|Number=Sing/
          form2 = 'емуже'
        elsif morph =~ /Case=Dat\|Gender=Neut\|Number=Sing/
          form2 = 'емуже'
        elsif morph =~ /Case=Loc\|Gender=Masc\|Number=Sing/
          form2 = 'немьже'
        elsif morph =~ /Case=Loc\|Gender=Neut\|Number=Sing/
          form2 = 'немьже'
        elsif morph =~ /Case=Gen\|Gender=Fem\|Number=Sing/
          form2 = 'еиже'
        elsif morph =~ /Case=Dat\|Gender=Fem\|Number=Sing/
          form2 = 'еиже'
        elsif morph =~ /Case=Acc\|Gender=Fem\|Number=Sing/
          form2 = 'ѭже'
        elsif morph =~ /Case=Acc\|Number=Plur/
          form2 = 'ѩже'
        elsif morph =~ /Case=Nom\|Number=Plur/
          form2 = 'иже'
        else form2 = form
        end
      elsif lemma == 'ВЕСЬ'
        if morph =~ /Case=Gen\|Gender=Fem\|Number=Sing/
          form2 = 'вьсеѧ'
        elsif morph =~ /Case=Dat\|Gender=Fem\|Number=Sing/
          form2 = 'вьсеи'
        elsif morph =~ /Case=Loc\|Gender=Fem\|Number=Sing/
          form2 = 'вьси'
        elsif morph =~ /Case=Ins\|Gender=Fem\|Number=Sing/
          form2 = 'вьсеѭ'
        elsif morph =~ /Case=Dat\|Gender=Masc\|Number=Sing/
          form2 = 'вьсему'
        elsif morph =~ /Case=Dat\|Gender=Neut\|Number=Sing/
          form2 = 'вьсему'
        elsif morph =~ /Case=Ins\|Gender=Masc\|Number=Sing/
          form2 = 'всѣмь'
        elsif morph =~ /Case=Ins\|Gender=Neut\|Number=Sing/
          form2 = 'всѣмь'
        elsif morph =~ /Case=Nom\|Gender=Neut\|Number=Sing/
          form2 = 'вьсѣ'
        elsif morph =~ /Case=Nom\|Gender=Fem\|Number=Sing/
          form2 = 'вьсѧ'
        elsif morph =~ /Case=Acc\|Gender=Fem\|Number=Sing/
          form2 = 'всѫ'
        else form2 = form
        end
      elsif form =~ /ый\z/
        form2 = form.gsub(/ый\z/, 'ꙑ')
      elsif form =~ /ой\z/
        if morph =~ /Case=Gen\|Degree=Pos\|Gender=Fem\|Number=Sing\|Strength=Weak/
           form2 = form.gsub(/ой\z/, 'ꙑѩ')
        elsif morph =~ /Case=Nom\|Degree=Pos\|Gender=Masc\|Number=Sing\|Strength=Weak/
           form2 = form.gsub(/ой\z/, 'ꙑ')
        elsif morph =~ /Case=Dat\|Degree=Pos\|Gender=Fem\|Number=Sing\|Strength=Weak/
           form2 = form.gsub(/ой\z/, 'ѣи')
        elsif morph =~ /Case=Loc\|Degree=Pos\|Gender=Fem\|Number=Sing\|Strength=Weak/
           form2 = form.gsub(/ой\z/, 'ѣи')
        elsif morph =~ /Case=Ins\|Degree=Pos\|Gender=Fem\|Number=Sing\|Strength=Weak/
           form2 = form.gsub(/ой\z/, 'оѭ')
        else form2 = form.gsub(/й\z/, 'и')
        end
      elsif form =~ /ые\z/                            
        form2 = form.gsub(/ые\z/, 'ии')
      elsif form =~ /ая\z/
        form2 = form.gsub(/ая\z/, 'аа')
      elsif form =~ /й/
        form2 = form.gsub(/й/,'и')
      elsif form =~ /м\z/
        if morph =~ /Case=Dat|Case=Nom|Case=Acc/
          form2 = form + 'ъ'
        else
          form2 = form + 'ь'
        end
      else
        form2 = form
      end
    elsif pos =~ /ADP/
      if lemma == 'В'
         form2 = 'въ'
      elsif lemma == 'С'
         form2 = 'съ'
      elsif lemma == 'К'
         form2 = 'къ'
      elsif lemma == 'ИЗ'
         form2 = 'изъ'
      elsif lemma == 'ПОД'
         form2 = 'подъ'
      elsif lemma == 'ОТ'
         form2 = 'отъ'
      elsif lemma == 'ПРОТИВ'
         form2 = form + 'ѫ'
      elsif lemma =~ /СКВОЗЬ/
        form2 = form.gsub(/ь\z/, 'ѣ')
      elsif form =~ /спустя|через/
        form2 = 'чрѣсъ'
      elsif lemma == 'ДЛЯ'
        form2 = 'дѣлꙗ'
      elsif lemma == 'ПОСЛЕ'
        form2 = 'послѣжде'
      elsif form =~ /вне|кроме/
        form2 = form.gsub(/е\z/,'ѣ')
      else form2 = form
      end
    elsif pos == 'CCONJ'
      if lemma == 'НО'
        form2 = 'нъ'
      else form2 = form
      end
    elsif form =~ /й/                     
      form2 = form.gsub(/й/, 'и')
    elsif form =~ /я/                    
      form2 = form.gsub(/я/, 'ꙗ')
    else
      form2 = form
    end

    STDOUT.puts [a[0], form2, lemma, pos, a[4], morph,head_id,rel,a[8],a[9]].join("\t")
  end
end
