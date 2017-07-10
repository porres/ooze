// This header causes flext.h and stk.h to be included as well as
// declaring the virtual class flext_stk.
#include <flstk.h>


#if !defined(FLEXT_VERSION) || (FLEXT_VERSION < 401)
#error You need at least flext version 0.4.1
#endif

// Include here whatever particular STK declarations are needed 
#include "Clarinet.h"
#include "PRCRev.h"
#include "JCRev.h"
#include "NRev.h"
#include "Echo.h"
#include "PitShift.h"
#include "Chorus.h"
#include "BiQuad.h"
#include "Resonate.h"


// The class clarinet corresponds to the object clarinet~ that
// may be instantiated in the PD environment.
class clarinet:
	public flext_stk
{

        // This causes mandatory flext header information to be inserted.
        // For instance, now PD will know the name of the setup function
        // for initializing signal processing code.
	FLEXT_HEADER_S(clarinet,flext_stk,setup)

public:

        // In this case, the clarinet object can only be instantiated given
        // an initial frequency.  Otherwise, the signal processing components
        // would not initially know how to process input excitation signals.
	clarinet(float initFreq);

protected:
        // These are object-specific functions provided for altering
        // the physical model's parameters.
	void setFreq(float f);
	void setVolume(float f);

	// These functions must be defined since they are defined virtually
        // in flstk.h
	virtual bool NewObjs(); // create STK instruments
	virtual void FreeObjs(); // destroy STK instruments
	virtual void ProcessObjs(int n);  // do DSP processing

        // This function must be defined for any flext object that
        // processes signals at the audio rate.
	virtual void m_signal(int n, float *const *in, float *const *out);
	stk::Instrmnt *inst;
	stk::Effect *effect;
	stk::BiQuad filter;
private:
	float frequency;
	float volume;
	
        // The setup function 
	static void setup(t_classid c);

        // Callback wrapper allows PD's real-time processing environment
        // to call a function defined in clarinet.cpp.
        // For every registered method (see below), a callback must also be declared.
	FLEXT_CALLBACK_F(setFreq)
	FLEXT_CALLBACK_F(setVolume)
};


// This tells PD to associate the object name clarinet~ with the
// class clarinet.  The third argument specifies that the clarinet~
// object may only be instantiated if an argument is provided.
// In this case, that argument is the initial pitch.
FLEXT_NEW_DSP_1("clarinet~",clarinet,float)
 
clarinet::clarinet(float initFreq)
{ 
	AddInSignal();
	AddInFloat();
	AddInFloat();
	AddOutSignal(1);  

	// Either inst or effect may be used depending on whether you
	// are implementing an STK instrument or an STK effect.
	inst= NULL;
	effect=NULL;
	// Here STK characteristics for the clarinet are initialized
	frequency=initFreq;
	filter.setResonance( 420, 0.99, true );
}

void clarinet::setup(t_classid c)
{
  // Methods describing how the PD object should handle 
  // input messages need to be registered.
  //
  // Register that numbers passed in the third inlet should cause the frequency
  // of the clarinet to be set using the setFreq() function.
  FLEXT_CADDMETHOD(c,2,setFreq);
  // Register that numbers passed in the second inlet should cause the volume
  // of the clarinet to be set using the setVolume() function.
  FLEXT_CADDMETHOD(c,1,setVolume);
}

// This is the function that is called when a float is passed
// in the third (rightmost) inlet.
void clarinet::setFreq(float freq){
	frequency=freq;
	inst->setFrequency(frequency);
}

// This is the function that is called when a float is passed
// in the second (middle) inlet.
void clarinet::setVolume(float vol){
	volume=vol/(float)127;
	inst->noteOn(frequency,volume);
}

// Allocate memory for the STK instrument
bool clarinet::NewObjs()
{
	bool ok = true;

	// set up objects
	try {
	  // Either instantiate an instrument or an effect
	  //inst = new clarinet(frequency);	
	  inst->noteOn(frequency,0.2);		
	  //effect=new Echo(44100*3);
	  //((Echo*)effect)->setDelay(1000);
	}
	catch (stk::StkError &) {
		post("%s - Clarinet() setup failed!",thisName());
		ok = false;
	}
	return ok;
}


// destroy the STK instruments
void clarinet::FreeObjs()
{
  /*if(inst) 
	delete inst;
	if(effect)
	delete effect;*/
}

// this is called on every DSP block.
void clarinet::ProcessObjs(int n)
{	
	StkFloat temp;
	while(n--) {
		temp=inst->tick();					
		Outlet(0).tick(temp);		
	}
}

void clarinet::m_signal(int n, float *const *in, float *const *out)
{	
	const float *ins1    =  in[0];	
	float *outs          = out[0];
	
	StkFloat temp;
	while(n--) {
		//*outs++=((Clarinet *)inst)->tick(*ins1++);
		*outs++=inst->tick();
	}
}  // end m_signal

