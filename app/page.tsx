'use client';

import { useEffect, useMemo, useRef, useState } from 'react';

export default function Page() {
  const [mm, setMm] = useState('25');
  const [secLeft, setSecLeft] = useState(0);
  const [running, setRunning] = useState(false);
  const tickRef = useRef<number | null>(null);

  const mmNum = Number(mm) || 0;
  const mmValid = mmNum > 0 && mmNum <= 180;

  const mmss = useMemo(() => {
    const m = Math.floor(secLeft / 60);
    const s = secLeft % 60;
    return `${String(m).padStart(2,'0')}:${String(s).padStart(2,'0')}`;
  }, [secLeft]);

  useEffect(() => {
    document.title = running ? `${mmss} ⏱️ Timer` : 'Timer';
  }, [mmss, running]);

  useEffect(() => {
    if (!running) return;
    tickRef.current = window.setInterval(() => {
      setSecLeft(prev => {
        if (prev <= 1) {
          try {
            const a = new Audio('data:audio/wav;base64,UklGRiQAAABXQVZFZm10IBAAAAABAAEAgD4AAAB9AAACABAAZGF0YQAAAAA=');
            a.play().catch(() => {});
          } catch {}
          if (tickRef.current) clearInterval(tickRef.current);
          tickRef.current = null;
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
    return () => {
      if (tickRef.current) clearInterval(tickRef.current);
      tickRef.current = null;
    };
  }, [running]);

  const handleStart = () => {
    if (!mmValid) return;
    setSecLeft(mmNum * 60);
    setRunning(true);
  };

  return (
    <main className="min-h-dvh flex items-center justify-center bg-gray-50">
      <div className="w-full max-w-md mx-auto p-6 rounded-2xl bg-white shadow">
        <h1 className="text-2xl font-semibold mb-4">シンプルタイマー</h1>

        <label className="block text-sm mb-2">分を入力（1〜180）</label>
        <input
          type="number"
          min={1}
          max={180}
          value={mm}
          onChange={(e) => setMm(e.target.value)}
          className="w-full border rounded-lg px-3 py-2 mb-4 outline-none focus:ring"
        />

        <div className="text-6xl font-mono text-center tracking-widest mb-6">{mmss}</div>

        <div className="grid grid-cols-2 gap-3">
          {!running && secLeft === 0 && (
            <button
              onClick={handleStart}
              disabled={!mmValid}
              className="col-span-2 py-3 rounded-xl bg-black text-white disabled:opacity-40"
            >
              開始
            </button>
          )}
          {running && (
            <button onClick={() => setRunning(false)} className="py-3 rounded-xl bg-gray-200">一時停止</button>
          )}
          {!running && secLeft > 0 && (
            <>
              <button onClick={() => secLeft > 0 && setRunning(true)} className="py-3 rounded-xl bg-black text-white">再開</button>
              <button onClick={() => { setRunning(false); setSecLeft(0); }} className="py-3 rounded-xl bg-gray-200">リセット</button>
            </>
          )}
        </div>

        <p className="text-xs text-gray-500 mt-4">
          終了時に短いビープ音を鳴らします。ブラウザの自動再生制限で鳴らない場合があります。
        </p>
      </div>
    </main>
  );
}
