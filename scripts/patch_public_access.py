from pathlib import Path
import re

path = Path('/home/ubuntu/dynastie-bitulu/client/src/pages/Home.tsx')
text = path.read_text()

login = r'''function LoginDialog({ open, onOpenChange }: { open: boolean; onOpenChange: (value: boolean) => void }) {
  const [mode, setMode] = useState<'login' | 'signup'>('login');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (mode === 'signup' && !firstName.trim()) { toast.error('Le prénom est requis pour créer votre profil.'); return; }
    setLoading(true);
    const result = mode === 'login'
      ? await supabase.auth.signInWithPassword({ email, password })
      : await supabase.auth.signUp({ email, password, options: { data: { first_name: firstName.trim(), last_name: lastName.trim() } } });
    setLoading(false);
    if (result.error) { toast.error(result.error.message); return; }
    toast.success(mode === 'login' ? 'Votre archive est ouverte.' : 'Compte créé. Vérifiez votre email si nécessaire.');
    onOpenChange(false);
  };
  return <Dialog open={open} onOpenChange={onOpenChange}><DialogContent className="border-copper/20 bg-paper p-0 sm:max-w-md"><div className="border-b border-ink/10 bg-sage/20 px-7 py-6"><DialogHeader><p className="archive-label mb-2">Accès privé</p><DialogTitle className="font-display text-3xl text-ink">{mode === 'login' ? 'Entrer dans la mémoire' : 'Rejoindre la dynastie'}</DialogTitle><DialogDescription className="pt-2 text-ink/60">Votre espace reste protégé par les règles de confidentialité de la famille.</DialogDescription></DialogHeader></div><form onSubmit={submit} className="space-y-5 px-7 py-7">{mode === 'signup' && <div className="grid gap-4 sm:grid-cols-2"><div><Label htmlFor="first-name">Prénom <span className="text-copper">*</span></Label><Input id="first-name" required value={firstName} onChange={e => setFirstName(e.target.value)} className="mt-2 h-11 rounded-none border-ink/15 bg-white/60" /></div><div><Label htmlFor="last-name">Nom</Label><Input id="last-name" value={lastName} onChange={e => setLastName(e.target.value)} className="mt-2 h-11 rounded-none border-ink/15 bg-white/60" /></div></div>}<div><Label htmlFor="email">Email</Label><Input id="email" type="email" required value={email} onChange={e => setEmail(e.target.value)} className="mt-2 h-11 rounded-none border-ink/15 bg-white/60" /></div><div><Label htmlFor="password">Mot de passe</Label><Input id="password" type="password" required minLength={6} value={password} onChange={e => setPassword(e.target.value)} className="mt-2 h-11 rounded-none border-ink/15 bg-white/60" /></div><Button disabled={loading} className="h-12 w-full rounded-none bg-copper text-white hover:bg-copper/90">{loading ? 'Ouverture…' : mode === 'login' ? 'Ouvrir mon espace' : 'Créer mon accès'}<ChevronRight className="ml-2 size-4" /></Button><button type="button" onClick={() => setMode(mode === 'login' ? 'signup' : 'login')} className="w-full text-center text-sm text-ink/55 underline decoration-copper/60 underline-offset-4">{mode === 'login' ? 'Je n’ai pas encore de compte' : 'J’ai déjà un accès'}</button></form></DialogContent></Dialog>;
}'''

public_home = r'''function PublicHome({ onLogin }: { onLogin: () => void }) {
  const [publicRecords, setPublicRecords] = useState<RecordItem[]>([]);
  const [publicLoaded, setPublicLoaded] = useState(false);
  useEffect(() => {
    let active = true;
    (async () => {
      const [events, stories, albums] = await Promise.all([
        supabase.from('events').select('id,title,description,event_date,created_at,visibility').eq('visibility', 'PUBLIC').order('created_at', { ascending: false }).limit(12),
        supabase.from('stories').select('id,title,content,created_at,visibility').eq('visibility', 'PUBLIC').order('created_at', { ascending: false }).limit(12),
        supabase.from('albums').select('id,name,description,album_date,created_at,visibility').eq('visibility', 'PUBLIC').order('created_at', { ascending: false }).limit(12),
      ]);
      if (!active) return;
      const merged = [
        ...(events.data || []),
        ...(stories.data || []),
        ...(albums.data || []).map(item => ({ ...item, title: item.name, event_date: item.album_date })),
      ].sort((a, b) => String(b.created_at).localeCompare(String(a.created_at)));
      setPublicRecords(merged);
      setPublicLoaded(true);
    })();
    return () => { active = false; };
  }, []);
  return <div className="min-h-screen bg-paper text-ink"><header className="absolute inset-x-0 top-0 z-20"><div className="mx-auto flex max-w-7xl items-center justify-between gap-3 px-5 py-6 md:px-10"><div className="flex min-w-0 items-center gap-3"><div className="mark-symbol mark-hero shrink-0"><span /><span /><i /></div><div className="min-w-0 border-l border-copper/60 pl-3"><p className="font-display text-xl leading-none sm:text-2xl">Dynastie</p><p className="hidden font-display text-[11px] font-semibold uppercase tracking-[0.38em] text-copper sm:block">BITULU · ARCHIVE FAMILIALE</p><p className="font-display text-[9px] font-semibold uppercase tracking-[0.28em] text-copper sm:hidden">BITULU</p></div></div><div className="flex shrink-0 items-center gap-3"><button className="hidden text-xs font-semibold uppercase tracking-[0.18em] text-white/80 hover:text-white md:block" onClick={onLogin}>Accès membre</button><Button onClick={onLogin} className="rounded-none bg-copper px-4 text-[10px] uppercase tracking-[0.14em] text-white hover:bg-copper/90 sm:px-5 sm:text-xs"><span className="sm:hidden">Entrer</span><span className="hidden sm:inline">Ouvrir l’archive</span></Button></div></div></header><main><section className="relative isolate min-h-[720px] overflow-hidden bg-[#584e46]"><div className="absolute inset-0 bg-cover bg-center" style={{ backgroundImage: "url('https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=1800&q=85')" }} /><div className="absolute inset-0 bg-gradient-to-r from-[#302b27]/95 via-[#3d352e]/70 to-[#3d352e]/25" /><div className="relative mx-auto flex min-h-[720px] max-w-7xl items-end px-5 pb-20 pt-28 md:px-10 md:pb-28 md:pt-0"><div className="max-w-2xl text-white"><p className="mb-5 text-xs font-semibold uppercase tracking-[0.28em] text-[#e3bb9f]">Archive familiale privée</p><h1 className="font-display text-6xl leading-[.93] tracking-[-.03em] md:text-8xl">Notre histoire.<br /><em className="text-[#e9c6aa]">Nos vies.</em><br />Notre mémoire.</h1><p className="mt-7 max-w-lg text-lg leading-8 text-white/72">Un lieu calme pour conserver les liens, les récits et les traces qui traversent les générations.</p><div className="mt-9 flex flex-wrap gap-3"><Button onClick={onLogin} className="h-12 rounded-none bg-[#e8c1a4] px-6 text-sm font-semibold text-[#3e322b] hover:bg-white">Accéder à l’espace membre <ChevronRight className="ml-2 size-4" /></Button><a href="#public-archive" className="flex h-12 items-center border border-white/35 px-6 text-sm text-white/90 transition hover:border-white">Voir les fragments publics</a></div></div></div><div className="absolute bottom-0 left-0 right-0 h-16 bg-paper [clip-path:polygon(0_100%,100%_0,100%_100%)]" /></section><section id="public-archive" className="relative bg-paper px-5 py-20 md:px-10 md:py-28"><div className="archive-binding" /><div className="mx-auto max-w-7xl"><div className="mb-10 flex flex-col justify-between gap-4 md:flex-row md:items-end"><div><p className="archive-label mb-4">Consultation visiteur · PUBLIC uniquement</p><h2 className="font-display text-5xl leading-none text-ink">Les fragments ouverts</h2><p className="mt-4 max-w-xl text-base leading-7 text-ink/60">Les visiteurs peuvent découvrir ce que la famille a explicitement choisi de rendre public. Les contenus familiaux et privés restent protégés.</p></div><span className="archive-stamp">Sans compte</span></div>{publicLoaded && publicRecords.length ? <div className="grid gap-4 md:grid-cols-3">{publicRecords.map(record => <article key={record.id} className="archive-record bg-white/55 p-6"><p className="archive-label">{record.event_date || record.created_at?.slice(0, 10) || 'Archive publique'}</p><h3 className="mt-3 font-display text-3xl">{record.title || 'Sans titre'}</h3><p className="mt-3 text-sm leading-6 text-ink/60">{record.description || record.content || 'Aucun descriptif public enregistré.'}</p></article>)}</div> : <EmptyState title={publicLoaded ? 'Aucun fragment public' : 'Lecture des fragments publics…'} text={publicLoaded ? 'La famille n’a encore rendu aucun événement, récit ou album accessible aux visiteurs.' : 'Les contenus explicitement publics sont en cours de lecture.'} />}</div></section><section id="principles" className="relative bg-paper px-5 py-20 md:px-10 md:py-28"><div className="archive-binding" /><div className="mx-auto grid max-w-7xl gap-12 md:grid-cols-[1.1fr_1.9fr] md:gap-24"><div><p className="archive-label mb-4">Registre 01 · Fondation</p><h2 className="font-display text-5xl leading-none text-ink">Pas un réseau social.<br /><span className="text-copper">Un héritage.</span></h2><div className="mt-9 flex items-center gap-3 text-[10px] font-semibold uppercase tracking-[.18em] text-ink/45"><span className="h-px w-9 bg-copper" />Visibilité maîtrisée · mémoire durable</div></div><div className="grid gap-px bg-ink/10 sm:grid-cols-2">{[['01','Mémoire','Les événements, les visages et les histoires importantes restent à leur place.'],['02','Transmission','Chaque génération peut comprendre d’où elle vient et laisser une trace.'],['03','Confidentialité','Chaque contenu possède sa propre règle de visibilité, de public à privé.'],['04','Continuité','Les profils restent, les liens se transmettent, l’administration se successionne.']].map(([n,t,d]) => <div key={n} className="archive-record bg-paper p-7"><span className="font-display text-4xl text-copper">{n}</span><p className="archive-label mt-5">Principe fondateur</p><h3 className="mt-2 text-lg font-semibold">{t}</h3><p className="mt-3 text-sm leading-6 text-ink/60">{d}</p></div>)}</div></div></section></main><footer className="border-t border-ink/10 bg-sage/20 px-5 py-8 md:px-10"><div className="mx-auto flex max-w-7xl flex-col justify-between gap-4 text-xs text-ink/55 md:flex-row md:items-center"><span>Dynastie BITULU</span><span>Une archive pensée pour durer.</span></div></footer></div>;
}'''

text, n1 = re.subn(r'function LoginDialog.*?\nfunction PublicHome', login + '\nfunction PublicHome', text, flags=re.S)
text, n2 = re.subn(r'function PublicHome.*?\nfunction Dashboard', public_home + '\nfunction Dashboard', text, flags=re.S)
if n1 != 1 or n2 != 1:
    raise SystemExit(f'Unexpected replacement counts: login={n1}, public={n2}')
path.write_text(text)
