# coding: utf-8
srb = File.open('sr_set-ud-dev.conllu')

def translit_sr(t)
  t.gsub(/ja/,'ꙗ').gsub(/ju/,'ю').gsub(/je/,'е').gsub(/ji/,'и').gsub(/jo/,'е').gsub(/lj/,'ль').gsub(/rj/,'рь').gsub(/nj/,'нь').gsub(/Ja/,'Ꙗ').gsub(/Ju/,'Ю').gsub(/Je/,'Е').gsub(/Ji/,'И').gsub(/Jo/,'Е').gsub(/Lj/,'Ль').gsub(/Rj/,'Рь').gsub(/Нь/,'Nj').gsub(/a/,'а').gsub(/b/,'б').gsub(/c/,'ц').gsub(/č/,'ч').gsub(/ć/,'щ').gsub(/d/,'д').gsub(/e/,'е').gsub(/f/,'ф').gsub(/g/,'г').gsub(/h/,'х').gsub(/i/,'и').gsub(/j/,'и').gsub(/k/,'к').gsub(/l/,'л').gsub(/m/,'м').gsub(/n/,'н').gsub(/o/,'о').gsub(/p/,'п').gsub(/r/,'р').gsub(/s/,'с').gsub(/t/,'т').gsub(/u/,'ѹ').gsub(/v/,'в').gsub(/z/,'з').gsub(/š/,'ш').gsub(/ž/,'ж').gsub(/đ/,'жд').gsub(/â/,'а').gsub(/y/,'ы').gsub(/x/,'кс').gsub(/ﬂ/,'фл').gsub(/A/,'А').gsub(/B/,'Б').gsub(/C/,'Ц').gsub(/Č/,'Ч').gsub(/Ć/,'Щ').gsub(/D/,'Д').gsub(/E/,'Е').gsub(/F/,'Ф').gsub(/G/,'Г').gsub(/H/,'Х').gsub(/I/,'И').gsub(/J/,'И').gsub(/K/,'К').gsub(/L/,'Л').gsub(/M/,'М').gsub(/N/,'Н').gsub(/O/,'О').gsub(/P/,'П').gsub(/R/,'Р').gsub(/S/,'С').gsub(/T/,'Т').gsub(/U/,'Ѹ').gsub(/V/,'В').gsub(/w/,'ѹ').gsub(/W/,'Ѹ').gsub(/X/,'Х').gsub(/Y/,'Ы').gsub(/Z/,'З').gsub(/Ž/,'Ж').gsub(/Š/,'Ш').gsub(/Đ/,'Жд')
end

srb.each_line do |l|
  if l =~ /#/
    STDOUT.puts l
  elsif l == "\n"
    STDOUT.puts l
  else
    a = l.split()
    form = translit_sr(a[1])
    lemma = translit_sr(a[2])
    pos = a[3]
    morph = a[5]
    head_id = a[6]
    rel = a[7]
    if pos =~ /VERB|AUX/
      if morph =~ /Person=3\|Tense=Pres\|VerbForm=Fin/
        if morph =~ /Number=Sing/
          if form == 'е'
            form2 = 'естъ'
           else
            form2 =  form + 'тъ'
          end
        elsif morph =~ /Number=Plur/
          if form =~ /е\z/
            form2 = form.gsub(/е\z/,'ѧтъ')
          elsif form =~ /ѹ\z/
            form2 = form.gsub(/ѹ\z/,'ѫтъ')
          else
            form2 = form.gsub(/ю\z/,'ѭтъ')
          end
        end
      elsif morph =~ /Gender=Masc\|Number=Sing\|Tense=Past\|VerbForm=Part\|Voice=Act/
        form2 = form.gsub(/о\z/,'лъ')
      else
        form2 = form
      end
    elsif pos == 'PROPN' and morph =~ /Case=Nom\|Gender=Masc\|Number=Sing/
      if form =~ /ч\z|ш\z|ж\z|ц\z|щ\z/
        form2 = form + 'ь'
      elsif form =~ /а\z|е\z|и\z|о\z|ѹ\z|ы\z|ь\z|и\z|ꙗ\z|\.\z/
        form2 = form
      else
        form2 = form + 'ъ'
      end
    elsif pos == 'NOUN'
      if morph =~ /Case=Nom\|Gender=Masc\|Number=Sing/
        if form =~ /ч\z|ш\z|ж\z|ц\z|щ\z/
          form2 = form + 'ь'
        elsif form =~ /а\z|е\z|и\z|о\z|ѹ\z|ы\z|ь\z|и\|\z|\.\z/
          form2 = form
        else
          form2 = form + 'ъ'
        end
      elsif morph =~ /Case=Nom\|Gender=Fem\|Number=Sing/
        unless form =~ /а\z|ꙗ\z/
          form2 = form + 'ь'
        else
          form2 = form
        end
      elsif morph =~ /Case=Gen\|Gender=Fem\|Number=Sing/
        if lemma =~ /ча\z|ша\z|жа\z|ца\z|ща\z/
          form2 = form.gsub(/.\z/,'ѧ')
        elsif lemma =~ /а\z/
          form2 = form.gsub(/.\z/,'ы')
        elsif lemma =~ /я\z/
          form2 = form.gsub(/.\z/,'ѧ')
        else form2 = form
        end
      elsif morph =~ /Case=Acc\|Gender=Fem\|Number=Sing/
        if form =~ /ю\z/
          form2 = form.gsub(/ю\z/,'ѭ')
        elsif form =~ /ѹ\z/
          form2 = form.gsub(/ѹ\z/,'ѫ')
        else
          form2 = form + 'ь'
        end
      elsif morph =~ /Case=Gen\|Gender=Masc\|Number=Plur/
        if form =~ /а\z/
          form2 = form.gsub(/а\z/,'ъ')
        elsif lemma =~ /ь\z/
          form2 = form.gsub(/ꙗ\z/,'ь')
        elsif form =~ /ꙗ\z/
          form2 = form.gsub(/ꙗ\z/,'и')
        else form2 = form 
        end
      elsif morph =~ /Animacy=Inan\|Case=Acc\|Gender=Masc\|Number=Sing/
        if form =~ /ч\z|ш\z|ж\z|ц\z|щ\z/
          form2 = form + 'ь'
        elsif form =~ /а\z|е\z|и\z|о\z|ѹ\z|ы\z|ь\z|и\z|ꙗ\z|\.\z/
          form2 = form
        else
          form2 = form + 'ъ'
        end
       else form2 = form
      end
     elsif pos == 'ADJ'
      if form =~ /х\z/
        form2 = form + 'ъ'
       elsif form =~ /м\z/
        if morph =~ /Dat|Nom|Acc/
          form2 = form + 'ъ'
        elsif morph =~ /Loc/
          if morph =~ /Plur/
            form2 = form.gsub(/м\z/,'хъ')
          else
            form2 = form + 'ь'
          end
        elsif morph =~ /Ins.*Plur/
          form2 = form + 'и'
        else
          form2 = form + 'ь'
        end
       else
        form2 = form
      end
     elsif pos == 'PRON'
       if morph =~ /Case=Acc\|PronType=Prs\|Reflex=Yes/
         form2 = 'сѧ'
         STDERR.puts form2, form, lemma, morph
       else
         form2 = form
       end
     else
       form2 = form
    end

    if form2 =~ /а\z|е\z|и\z|о\z|ѹ\z|ы\z|ь\z|ъ\z|ꙗ\z|А\z|Е\z|И\z|О\z|Ѹ\z|ю\z|Ю\z|Ꙗ\z|ѧ\z|ѫ\z|ѩ\z|ѭ\z|ѣ\z/
      form3 = form2
    elsif form2 =~ /ч\z|ш\z|ж\z|ц\z|щ\z/
      form3 = form2 + 'ь'
    elsif pos == 'PUNCT'
      form3 = form2
    else
      form3 = form2 + 'ъ'
    end
        
    STDOUT.puts [a[0], form3, lemma, pos, a[4], morph,head_id,rel,a[8],a[9]].join("\t")
  end
end
